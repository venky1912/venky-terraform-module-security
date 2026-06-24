# Changelog

## [1.0.1](https://github.com/venky1912/venky-terraform-module-security/compare/v1.0.0...v1.0.1) (2026-06-24)


### Bug Fixes

* pin provider versions to supported range ([#2](https://github.com/venky1912/venky-terraform-module-security/issues/2)) ([dc9f541](https://github.com/venky1912/venky-terraform-module-security/commit/dc9f5413a6765f8dd4508d12564088309ee7767f))

## [1.0.0](https://github.com/venky1912/venky-terraform-module-security/compare/v0.1.0...v1.0.0) (2026-06-24)


### ⚠ BREAKING CHANGES

* Module interface completely redesigned.
    - Generic KMS keys with configurable policies
    - Generic security groups with flexible ingress/egress rules
    - Supports any service (EKS, RDS, EC2, ALB, etc.)

### Features

* refactor to generic security module for any workload ([f81617a](https://github.com/venky1912/venky-terraform-module-security/commit/f81617a0325107f6eef75055c0bad3b9881dae97))

## [0.1.0] - 2026-06-24

### Added

- Initial release
- KMS key for EKS cluster encryption with key rotation
- EKS cluster security group with least-privilege rules
- EKS node security group with node-to-node communication
- Additional custom security group rules support
