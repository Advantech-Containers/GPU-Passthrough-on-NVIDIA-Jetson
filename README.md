# GPU Passthrough on NVIDIA Jetson™

**Version:** 2.0  
**Release Date:** April 2025  
**Copyright:** © 2025 Advantech Corporation. All rights reserved.

## Overview

The  GPU Passthrough on NVIDIA Jetson™ provides a comprehensive environment for building and deploying AI applications on NVIDIA Jetson hardware. This container features full hardware acceleration support, optimized AI frameworks, and industrial-grade reliability.

### Key Features

- **Full Hardware Acceleration:** Optimized access to GPU, NVENC/NVDEC, and DLA
- **Complete AI Framework Stack:** PyTorch, TensorFlow, ONNX Runtime, and TensorRT
- **Industrial Vision Support:** Accelerated OpenCV and GStreamer pipelines
- **Edge AI Capabilities:** Support for computer vision, and time-series analysis
- **Performance Optimized:** Tuned specifically for Jetson Orin NX 8GB

### Supported Hardware

| Specification | Details |
|:--------------|:--------|
| Platform | NVIDIA Jetson (Orin-nano, Orin-nx, Xavier AGX) |
| GPU Architecture | Ampere, Volta, Pascal |
| Memory | 4GB, 8GB, 16GB or 32GB shared |
| JetPack | 6.x (r36.4.0) |

For troubleshooting, see the [Troubleshooting Wiki](https://github.com/Advantech-EdgeSync-Containers/GPU-Passthrough-on-NVIDIA-Jetson/wiki/Advantech-Containers'-Troubleshooting-Guide).

## Table of Contents

- [System Requirements](#system-requirements)
- [Directory Structure](#directory-structure)
- [Before You Start](#Before-You-Start)
- [Quick Start](#quick-start)
- [Supported AI Model Formats](#Supported-AI-Model-Formats)
- [Hardware Acceleration Support](#Hardware-Acceleration-Support)
- [Video/Camera Processing](#Video/Camera-Processing)
- [Best Practices](#Best-Practices)
- [Limitations](#limitations)
- [License](#license)
- [Support](#Support)

## System Requirements

### General Required Packages on Host System

Install these components on your Advantech device before using this toolkit.

| Component | Version |
|:----------|:--------|
| JetPack | 6.x (r36.4.0) |
| CUDA | 12.6.68 |
| cuDNN | 9.3.0.75 |
| TensorRT | 10.3.0.30 |
| OpenCV | 4.8.0 |
| Docker | 28.1.1 or later |
| Docker Compose | 2.39.1 or later |
| NVIDIA Container Toolkit | 1.11.0 or later |

Component versions depend on your **JetPack Version**. See [NVIDIA JetPack Documentation](https://developer.nvidia.com/embedded/jetpack) for package version and for installation please refer to [SDK Manager](https://developer.nvidia.com/sdk-manager). 

### Container Environment

The Docker container includes the following pre-configured components.

| Component | Version | Description |
|:----------|:--------|:------------|
| CUDA | 12.6.68 | GPU computing platform |
| cuDNN | 9.3.0.75 | Deep Neural Network library |
| TensorRT | 10.3.0.30 | Inference optimizer and runtime |
| PyTorch | 2.0.0+nv23.02 | Deep learning framework |
| TensorFlow | 2.12.0 | Machine learning framework |
| ONNX Runtime | 1.16.3 | Cross-platform inference engine |
| VPI | 3.2.4 | Vision Programming Interface |
| Vulkan | 1.3.204 | Graphics and compute API |
| OpenCV | 4.8.0 | Computer vision library with CUDA |
| GStreamer | 1.16.2 | Multimedia framework |

## Directory Structure

```
GPU-Passthrough-on-NVIDIA-Jetson/
├── build.sh                         # Build/setup script
├── init.sh                          # Initialization script
├── wise-bench.sh                    # Hardware & GPU diagnostic tool
├── docker-compose.yml               # Container configuration
├── data/                            # Data assets
│   └── images/                      # Project images
│       └── wisebenchlog.png         # WiseBench result visualization
├── LICENSE                          # Project license
└── README.md                        # Documentation
```

## Before You Start
Before proceeding, ensure that your system meets the required [general-required-packages-on-host-system](#general-required-packages-on-host-system). If you encounter any issues or inconsistencies in your environment, please consult our [Troubleshooting Wiki](https://github.com/Advantech-EdgeSync-Containers/GPU-Passthrough-on-NVIDIA-Jetson/wiki/Advantech-Containers'-Troubleshooting-Guide) for solutions and to verify that all prerequisites are properly satisfied

- Ensure the following components are installed on your device along with other packages mentioned in the [general-required-packages-on-host-system](#general-required-packages-on-host-system):
  - **Docker**
  - **Docker Compose**
  - **NVIDIA Container Toolkit**
  - **NVIDIA Runtime** 

---

## Quick Start

### Step 1: Clone the Repository
```bash
git clone https://github.com/Advantech-EdgeSync-Containers/GPU-Passthrough-on-NVIDIA-Jetson.git
cd GPU-Passthrough-on-NVIDIA-Jetson
```

### Step 2: Set Permissions
Grant execute permissions to the setup scripts.
```bash
chmod +x *.sh
```
### Step 3: Start the Container

Launch the Docker environment. This script creates project directories, configures GPU access, and opens an interactive terminal inside the container.
```bash
./build.sh
```
### Step 4: Verify Installation (Optional)
Run the diagnostic script to confirm hardware acceleration is working.
```bash
./wise-bench.sh
```
The wise-bench script will run as below as per the system specifications.
![wise-bench](data/images/wisebenchlog.png)

---
## Supported AI Capabilities

### Vision Models

| Model Family | Versions | Performance (FPS) | Quantization Support |
|--------------|----------|-------------------|---------------------|
| YOLO | v3/v4/v5 (up to v5.6.0), v6 (up to v6.2), v7 (up to v7.0), v8 (up to v8.0) | YOLOv5s: 45-60 @ 640x640, YOLOv8n: 40-55 @ 640x640, YOLOv8s: 30-40 @ 640x640 | INT8, FP16, FP32 |
| SSD | MobileNetV1/V2 SSD, EfficientDet-D0/D1 | MobileNetV2 SSD: 50-65 @ 300x300, EfficientDet-D0: 25-35 @ 512x512 | INT8, FP16, FP32 |
| Faster R-CNN | ResNet50/ResNet101 backbones | ResNet50: 3-5 @ 1024x1024 | FP16, FP32 |
| Segmentation | DeepLabV3+, UNet | DeepLabV3+ (MobileNetV2): 12-20 @ 512x512 | INT8, FP16, FP32 |
| Classification | ResNet (18/50), MobileNet (V1/V2/V3), EfficientNet (B0-B2) | ResNet18: 120-150 @ 224x224, MobileNetV2: 180-210 @ 224x224 | INT8, FP16, FP32 |
| Pose Estimation | PoseNet, HRNet (up to W18) | PoseNet: 15-25 @ 256x256 | FP16, FP32 |



## Supported AI Model Formats

| Format | Support Level | Compatible Versions | Notes |
|--------|---------------|---------------------|-------|
| ONNX | Full | 1.10.0 - 1.16.3 | Recommended for cross-framework compatibility |
| TensorRT | Full | 7.x - 8.5.x | Best for performance-critical applications |
| PyTorch (JIT) | Full | 1.8.0 - 2.0.0 | Native support via TorchScript |
| TensorFlow SavedModel | Full | 2.8.0 - 2.12.0 | Recommended TF deployment format |
| TFLite | Partial | Up to 2.12.0 | May have limited hardware acceleration |

## Hardware Acceleration Support

| Accelerator | Support Level | Compatible Libraries | Notes |
|-------------|---------------|----------------------|-------|
| CUDA | Full | PyTorch, TensorFlow, OpenCV, ONNX Runtime | Primary acceleration method |
| TensorRT | Full | ONNX, TensorFlow, PyTorch (via export) | Recommended for inference optimization |
| cuDNN | Full | PyTorch, TensorFlow | Accelerates deep learning primitives |
| NVDEC | Full | GStreamer, FFmpeg | Hardware video decoding |
| NVENC | Full | GStreamer, FFmpeg | Hardware video encoding |
| DLA | Partial | TensorRT | Requires specific model optimization |

### Precision Support

| Precision | Support Level | Compatible Frameworks | Notes |
|-----------|---------------|------------------------|-------|
| FP32 | Full | All | Baseline precision, highest accuracy |
| FP16 | Full | All | 2x memory reduction, minimal accuracy impact |
| INT8 | Partial | TensorRT, ONNX Runtime | 4x memory reduction, requires calibration |
| INT4 | Limited | TensorRT (via plugins) | For models specifically optimized for INT4 |

## Video/Camera Processing

### GStreamer Integration

Built with NVIDIA-accelerated GStreamer plugins supporting:

| Feature | Support Level | Compatible Versions | Notes |
|---------|---------------|---------------------|-------|
| H.264 Encoding | Full | Up to High profile | Hardware accelerated via NVENC |
| H.265/HEVC Encoding | Full | Up to Main10 profile | Hardware accelerated via NVENC |
| VP9 Encoding | Full | Up to Profile 0 | Hardware accelerated |
| AV1 Encoding | Partial | Limited feature set | Experimental support |
| Hardware Decoding | Full | H.264/H.265/VP9 | Via NVDEC |
| RTSP Server | Full | GStreamer RTSP Server 1.16.2 | Streaming capabilities |
| RTSP Client | Full | GStreamer 1.16.2 | Low-latency streaming reception |
| Camera Capture | Full | V4L2, ArgusCamera | Direct camera integration |




## Best Practices

### Memory Management
- Pre-allocate GPU memory where possible
- Batch inference for better throughput
- Use stream processing for continuous data

### Precision Selection
- Start with FP16 for most models (good balance of accuracy/performance)
- Quantize to INT8 for vision models requiring higher throughput
- Use FP32 only when precision is critical

### Model Optimization
- Optimize model architecture for edge deployment
- Remove training-specific layers
- Apply pruning techniques for smaller models
- Use TensorRT for inference optimization

### Video Processing
- Use hardware-accelerated decoders/encoders
- Process at native resolution when possible
- Consider downsampling for higher throughput

## Limitations

1. **ONNX Runtime**: Limited GPU acceleration for complex operators.
2. **Mixed Precision**: Some operations may fall back to FP32 even in FP16 mode.
3. **Display Acceleration**: X11 forwarding performance may be limited.
4. **ONNX Runtime GPU Support**: For optimal performance, convert ONNX models to TensorRT engines.

## License

GNU General Public License v3.0

Copyright © 2025 Advantech Corporation. All rights reserved.
This software is provided by Advantech Corporation "as is" and any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose, are disclaimed.


For complete license details, see [LICENSE](LICENSE) for complete terms.

## Support

For documentation and troubleshooting, visit the [Troubleshooting Wiki](https://github.com/Advantech-EdgeSync-Containers/GPU-Passthrough-on-NVIDIA-Jetson/wiki/Advantech-Containers'-Troubleshooting-Guide).
For issues, submit to [GitHub Issues](https://github.com/Advantech-EdgeSync-Containers/GPU-Passthrough-on-NVIDIA-Jetson/issues).

Copyright © 2025 Advantech Corporation. All rights reserved.
