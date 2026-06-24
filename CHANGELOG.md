# Changelog

## [1.0.2](https://github.com/venky1912/venky-terraform-module-security/compare/v1.0.1...v1.0.2) (2026-06-24)


### Bug Fixes

* add explicit enable_key_rotation to example RDS key (CKV_AWS_7) ([#6](https://github.com/venky1912/venky-terraform-module-security/issues/6)) ([f7f9538](https://github.com/venky1912/venky-terraform-module-security/commit/f7f953830832f53ea732e600d048c5e4faa1a27e))
* skip AWS-0104 in security scan (intentional egress rule in example) ([#4](https://github.com/venky1912/venky-terraform-module-security/issues/4)) ([48403fa](https://github.com/venky1912/venky-terraform-module-security/commit/48403fadce0b5e865b06356d8b5b9f98bb3376f3))

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
