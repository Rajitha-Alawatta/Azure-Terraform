# 🚀 Azure Terraform Infrastructure

This repository contains modular, production-ready Terraform code for provisioning and managing a full-stack cloud platform on Microsoft Azure. The infrastructure is built around an **AKS-native architecture** with an integrated **data platform layer**, private networking, and container-based workload delivery — designed for scalable, cloud-native applications.

---

## 🏗️ Architecture Overview

The platform is structured into three layers:

### 1. Cloud Infrastructure (Azure)
Core Azure resources provisioned via reusable Terraform modules:

| Module | Description |
|--------|-------------|
| `azure-resource-group` | Resource group scoping all platform resources |
| `azure-network` | Virtual network with public and private subnets |
| `azure-kubernetes` | Managed Kubernetes cluster (AKS) with system and application node pools, autoscaling enabled |
| `azure-container-registry` | Private container registry (ACR) for Docker image storage |
| `azure-storage-account` | Azure Blob storage for Terraform remote state and data |
| `azure-private-endpoint` | Private endpoints for secure, network-isolated service access |
| `azure-private-dns-zone` | Private DNS zones for internal service resolution |
| `azure-role-assignment` | RBAC role assignments for managed identity access control |

### 2. Data Platform
A dedicated data engineering layer for ingestion, transformation, storage, and analytics:

| Module | Description |
|--------|-------------|
| `azure-eventhub` | High-throughput event streaming (equivalent to Apache Kafka) with consumer groups |
| `azure-data-factory` | Managed ETL/ELT pipelines with ADLS Gen2 linked service integration |
| `azure-synapse` | Unified analytics workspace combining data warehousing and Apache Spark processing |
| `azure-databricks` | Managed Databricks workspace (VNet-injected, no public IP) for large-scale data engineering |

### 3. Platform Components (Kubernetes)
Services deployed onto AKS for traffic management, ingress, and application workloads:

| Component | Description |
|-----------|-------------|
| **NGINX Ingress** | HTTP/S traffic routing with per-app ingress rules |
| **Cert-Manager + ClusterIssuer** | Automated TLS certificate management via Let's Encrypt |
| **Kubernetes Dashboard** | Web UI for cluster resource management |
| **Deployments / Services** | Application workload management with HPA (Horizontal Pod Autoscaler) |
| **Persistent Volume Claims** | Managed persistent storage for stateful workloads |

---

## 🔄 Why This Setup?

This platform is designed to support a **cloud-native, data-driven application** on Azure that requires:

- **Event streaming** — Event Hub handles real-time event ingestion from applications at scale
- **ETL/ELT pipelines** — Azure Data Factory orchestrates data movement between sources and the data lake
- **Big data processing** — Databricks provides a distributed Spark environment for large-scale transformations
- **Analytics at scale** — Synapse Analytics combines SQL data warehousing and Spark in a single workspace for BI and reporting
- **Containerised workloads** — AKS provides a managed Kubernetes platform with multi-node-pool support and auto-scaling
- **Private networking** — Private endpoints and DNS zones ensure all services communicate over the Azure backbone, never the public internet
- **Managed identity** — No credentials are stored in code; all access is granted via Azure Managed Identities and RBAC

---

## 🌍 Environments

| Environment | Description |
|-------------|-------------|
| `dev-test` | Development and testing environment |

---

## 🗃️ Remote State

Terraform state is stored remotely in **Azure Blob Storage** with environment-scoped state files, enabling team collaboration and consistent state management.

---

## 🔐 Security Highlights

- **No public IPs** on Databricks workspace (VNet injection)
- **Private endpoints** for ACR and storage — traffic never leaves the Azure network
- **Managed Identities** used across AKS, ADF, and Synapse — no service principal secrets
- **RBAC role assignments** scoped to the minimum required permissions
- **TLS enforced** on all ingress endpoints via Cert-Manager
