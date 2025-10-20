
---

# 🧩 Ad-Hoc Automation on Azure — Terraform + Ansible

A cloud automation project demonstrating how to provision multiple Azure Linux VMs using **Terraform**, configure **passwordless SSH**, and manage the infrastructure using **Ansible ad-hoc commands**.
This project showcases real-world DevOps practices for rapid infrastructure provisioning, configuration, and orchestration — without writing full playbooks.

---

## Table of Contents

* [Overview](#overview)
* [Architecture](#architecture)
* [Tech Stack](#tech-stack)
* [Project Structure](#project-structure)
* [Infrastructure Components](#infrastructure-components)
* [Getting Started](#getting-started)
* [Deployment](#deployment)
* [Ansible Ad-Hoc Automation](#ansible-ad-hoc-automation)
* [Screenshots](#screenshots)
* [Key Features](#key-features)
* [Reflection](#reflection)
* [Cleanup](#cleanup)
* [Contributing](#contributing)
* [License](#license)
* [Resources](#resources)

---

## 🧠 Overview

This project provisions **three Azure Ubuntu Linux virtual machines** using **Terraform**, sets up **passwordless SSH access**, and uses **Ansible ad-hoc commands** to perform automation tasks across multiple hosts and groups.

### Project Highlights

* Infrastructure provisioning using Terraform
* Passwordless SSH configuration for secure access
* Custom Ansible inventory management
* Real-time ad-hoc automation (ping, uptime, package install, service start)
* Nginx installation and service validation
* Clean-up using Terraform destroy

---

## 🏗️ Architecture

### Azure Infrastructure Overview

```
Azure Subscription (Free Tier)
│
└── Resource Group: adhoc-rg
    ├── Virtual Network: adhoc-vnet
    │   ├── Subnet: adhoc-subnet
    │   │   ├── adhoc-vm-0 (Web Server)
    │   │   ├── adhoc-vm-1 (App Server)
    │   │   └── adhoc-vm-2 (Database Server)
    │   │
    │   └── Public IPs (3)
    │
    └── Network Security Group: adhoc-nsg
        ├── Allow SSH (22)
        ├── Allow HTTP (80)
        └── Allow HTTPS (443)
```

Each VM was assigned a specific role using Terraform locals:

* **adhoc-vm-0** → Web Server (`web01`)
* **adhoc-vm-1** → App Server (`app01`)
* **adhoc-vm-2** → Database Server (`db01`)

---

## 💻 Tech Stack

### Infrastructure as Code

* **Terraform** (AzureRM Provider)
* **Azure Resource Manager**

### Configuration Management

* **Ansible**

### Cloud Platform

* **Microsoft Azure (Free Tier)**

### Operating System

* **Ubuntu 22.04 LTS**

### Networking

* **Azure Virtual Network (VNet)**
* **Subnets, Network Security Groups, and Public IPs**

---

## 📂 Project Structure

```
adhoc-azure/
│
├── terraform/
│   ├── main.tf                # VM, NSG, Network, Public IP definitions
│   ├── variables.tf           # Variable definitions
│   ├── outputs.tf             # Terraform outputs (VM IPs)
│   ├── backend.tf             # Backend configuration
│   ├── terraform.tfvars       # Variable values (gitignored)
│   └── .gitignore             # Ignored sensitive files
│
├── ansible/
│   └── inventory.ini          # Custom Ansible inventory
│
└── screenshots/               # Task result screenshots
```

---

## 🧱 Infrastructure Components

### Resource Group

| Name     | Location | Purpose                        |
| -------- | -------- | ------------------------------ |
| adhoc-rg | East US  | Contains all project resources |

### Network Configuration

| Component       | Name         | CIDR / Description         |
| --------------- | ------------ | -------------------------- |
| Virtual Network | adhoc-vnet   | 10.0.0.0/16                |
| Subnet          | adhoc-subnet | 10.0.1.0/24                |
| NSG             | adhoc-nsg    | Allows SSH (22), HTTP (80) |

### Virtual Machines

| Name       | Role  | Size         | OS           | Public IP          |
| ---------- | ----- | ------------ | ------------ | ------------------ |
| adhoc-vm-0 | web01 | Standard_B1s | Ubuntu 22.04 | (Terraform Output) |
| adhoc-vm-1 | app01 | Standard_B1s | Ubuntu 22.04 | (Terraform Output) |
| adhoc-vm-2 | db01  | Standard_B1s | Ubuntu 22.04 | (Terraform Output) |

---

## 🚀 Getting Started

### Prerequisites

Install the following tools:

```bash
az --version       # Azure CLI
terraform --version
ansible --version
```

Authenticate to Azure:

```bash
az login
az account set --subscription "<your-subscription-id>"
```

Generate an SSH key if you don’t have one:

```bash
ssh-keygen -t ed25519 
```

---

## ⚙️ Deployment

### Step 1: Initialize Terraform

```bash
cd terraform
terraform init
```

### Step 2: Validate and Plan

```bash
terraform validate
terraform plan
```

### Step 3: Apply Configuration

```bash
terraform apply -auto-approve
```

Terraform will output VM public IPs and roles:

```
ssh azureuser@<ip1>
ssh azureuser@<ip2>
ssh azureuser@<ip3>
```

---

## 🔐 Passwordless SSH Configuration

Copy your public SSH key to each VM:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub azureuser@<vm_public_ip> .ssh/id_rsa.pub"
```

Verify login:

```bash
ssh azureuser@<vm_public_ip>
```

---

## 📘 Ansible Inventory Configuration

Create the file: `ansible/inventory.ini`

```ini
[web]
<ip_of_vm0>

[app]
<ip_of_vm1>

[db]
<ip_of_vm2>

[all:vars]
ansible_user=azureuser
ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

---

## ⚡ Ansible Ad-Hoc Automation

### Verify Connectivity

```bash
ansible all -i ansible/inventory.ini -m ping
```

### Check System Uptime

```bash
ansible all -i ansible/inventory.ini -a "uptime"
```

### Install Nginx on Web Servers

```bash
ansible web -i ansible/inventory.ini -m apt -a "name=nginx state=present update_cache=yes" --become
```

### Enable and Start Nginx

```bash
ansible web -i ansible/inventory.ini -m service -a "name=nginx state=started enabled=yes" --become
```

### Check Disk Usage

```bash
ansible all -i ansible/inventory.ini -a "df -h"
```

---

## 🖼️ Screenshots

All screenshots are stored in the `/screenshots` folder, including:

* Terraform Apply Output
* Ansible Ping Test (Success)
* Nginx Installation
* Service Status (`active (running)`)
* Uptime and Disk Usage

---

## 🌟 Key Features

* End-to-end automation with Terraform and Ansible
* Secure passwordless SSH access
* Real-time orchestration using Ansible ad-hoc mode
* Dynamic IP mapping from Terraform outputs
* Infrastructure teardown to prevent cost

---

## 💬 Reflection

Ad-hoc commands are ideal for quick administrative tasks — verifying connectivity, checking uptime, or restarting services.
For complex, repeatable, or version-controlled automation, **Ansible playbooks** are the better approach.

This project bridges the gap between one-time operations and automated configuration management.

---

## 🧹 Cleanup

Destroy all resources to avoid Azure charges:

```bash
terraform destroy -auto-approve
```

---

## 🧾 .gitignore (Important)

```gitignore
# Terraform
*.tfstate
*.tfstate.backup
.terraform/
.terraform.lock.hcl
terraform.tfvars

# SSH keys
*.pem
*.pub
id_*
*.key

# Ansible cache
*.retry
__pycache__/
*.log

# System and Editor Files
.DS_Store
Thumbs.db
.vscode/
.idea/
```

---

## 🤝 Contributing

Contributions are welcome.
Please open an issue or submit a pull request for improvements.

---

## 📜 License

This project is for **educational and portfolio purposes only**.

---

## 📚 Resources

* [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Azure Virtual Network Overview](https://learn.microsoft.com/en-us/azure/virtual-network/)
* [Ansible Ad-Hoc Commands](https://docs.ansible.com/ansible/latest/cli/ansible.html)

---

*Author:* Owofola Olakunle (Lakunzy)

*Project Type:* DevOps Infrastructure Automation

*Platform:* Microsoft Azure (Free Tier)

*Date:* October 2025

*Channel:* [CyberLab Chronicles on YouTube](https://www.youtube.com/@CyberLabChronicles)

