#!/usr/bin/env bash
# GPU-Passthrough-on-NVIDIA-Jetson - Environment Init | Version 2.0.0 | Copyright (c) 2024-2025 Advantech Corporation
readonly SCRIPT_VERSION="2.0.0"
readonly JETSON_AI_LAB_REPO="https://pypi.jetson-ai-lab.dev/jp6/cu126"
readonly ONNXRUNTIME_VERSION="1.16.3"
readonly ONNX_VERSION="1.16.3"
readonly FLASK_VERSION="2.3.3"
readonly RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m'
readonly CYAN='\033[0;36m' BOLD='\033[1m' NC='\033[0m'
SKIP_VERIFY=false
FORCE_REINSTALL=false
ERROR_COUNT=0
TOTAL_STEPS=7
CURRENT_STEP=0
show_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    local percent=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    local filled=$((percent / 5))
    local empty=$((20 - filled))
    local bar=""
    local space=""
    for ((i=0; i<filled; i++)); do bar="${bar}█"; done
    for ((i=0; i<empty; i++)); do space="${space}░"; done
    printf "\r${CYAN}[%3d%%]${NC} ${GREEN}%s%s${NC} %-45s" "$percent" "$bar" "$space" "$1"
    if [[ $percent -ge 100 ]]; then echo ""; fi
}
print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║     █████╗ ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗████████╗███████╗ ██████╗██╗  ██╗          ║"
    echo "║    ██╔══██╗██╔══██╗██║   ██║██╔══██╗████╗  ██║╚══██╔══╝██╔════╝██╔════╝██║  ██║          ║"
    echo "║    ███████║██║  ██║╚██╗ ██╔╝███████║██╔██╗ ██║   ██║   █████╗  ██║     ███████║          ║"
    echo "║    ██╔══██║██║  ██║ ╚████╔╝ ██╔══██║██║╚██╗██║   ██║   ██╔══╝  ██║     ██╔══██║          ║"
    echo "║    ██║  ██║██████╔╝  ╚██╔╝  ██║  ██║██║ ╚████║   ██║   ███████╗╚██████╗██║  ██║          ║"
    echo "║    ╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝          ║"
    echo "║                 GPU-Passthrough-on-NVIDIA-Jetson - Environment Setup                     ║"
    echo "║                                    Version ${SCRIPT_VERSION}                                         ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-verify) SKIP_VERIFY=true; shift;;
            --force) FORCE_REINSTALL=true; shift;;
            --help|-h) echo "Usage: $0 [--skip-verify] [--force] [--help]"; exit 0;;
            *) shift;;
        esac
    done
}
run_install() {
    show_progress "Checking system requirements..."
    sleep 0.3
    show_progress "Removing conflicting packages..."
    pip3 uninstall -y onnxruntime onnxruntime-gpu onnxruntime-gpu-tensorrt ort-nightly ort-nightly-gpu onnx &>/dev/null || true
    pip3 cache purge &>/dev/null || true

    local need_install=true
    if [[ "$FORCE_REINSTALL" != "true" ]]; then
        if python3 -c "import onnxruntime as ort; exit(0 if 'CUDAExecutionProvider' in ort.get_available_providers() else 1)" &>/dev/null; then
            need_install=false
        fi
    fi

    if [[ "$need_install" == "true" ]]; then
        show_progress "Installing ONNX Runtime GPU ${ONNXRUNTIME_VERSION} from Jetson AI Lab..."
        if ! pip3 install --extra-index-url "${JETSON_AI_LAB_REPO}" "onnxruntime-gpu==${ONNXRUNTIME_VERSION}" &>/dev/null; then
            echo -e "\n${RED}ONNX Runtime GPU install failed${NC}"
            ERROR_COUNT=1
            return
        fi
    else
        show_progress "ONNX Runtime GPU already installed..."
    fi

    show_progress "Installing onnx ${ONNX_VERSION}..."
    pip3 install --extra-index-url "${JETSON_AI_LAB_REPO}" "onnx==${ONNX_VERSION}" --quiet &>/dev/null || true

    show_progress "Installing Flask and dependencies..."
    pip3 install "Flask==${FLASK_VERSION}" --quiet &>/dev/null || pip3 install flask --quiet &>/dev/null || true
    pip3 install --quiet numpy pillow pyyaml tqdm requests &>/dev/null || true

    if [[ "$SKIP_VERIFY" == "false" ]]; then
        show_progress "Verifying installation..."
        if ! python3 -c "import onnxruntime as ort; exit(0 if 'CUDAExecutionProvider' in ort.get_available_providers() else 1)" &>/dev/null; then
            ERROR_COUNT=1
        fi
    else
        show_progress "Skipping verification..."
    fi
}
print_result() {
    echo ""
    if [[ $ERROR_COUNT -eq 0 ]]; then
        echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}${BOLD}║                    ✓ Environment initialization completed successfully!                  ║${NC}"
        echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${BOLD}Installed:${NC}"
        python3 -c "import onnxruntime as ort; print(f'  ONNX Runtime GPU: {ort.__version__}')" 2>/dev/null || echo "  ONNX Runtime GPU: Not installed"
        python3 -c "import onnx; print(f'  ONNX: {onnx.__version__}')" 2>/dev/null || echo "  ONNX: Not installed"
        python3 -c "import flask; print(f'  Flask: {flask.__version__}')" 2>/dev/null || echo "  Flask: Not installed"
        echo ""
    else
        echo -e "${RED}${BOLD}╔══════════════════════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}${BOLD}║                    ✗ Environment initialization failed!                                  ║${NC}"
        echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════════════════════════════════════════╝${NC}"
        echo -e "${YELLOW}Run with --force to reinstall: ./init.sh --force${NC}"
    fi
}
main() {
    parse_args "$@"
    print_banner
    echo -e "${CYAN}Initializing environment...${NC}\n"
    run_install
    print_result
    exit $ERROR_COUNT
}
main "$@"
