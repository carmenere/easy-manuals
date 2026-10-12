# Docker
**Docker** is a **set of** container management **projects** ran by the **company** called **Docker**. These projects work together to provide a comprehensive platform for container deployment.

The most important projects are:
- **docker-cli** - a command line interface toolset: users create and manage Docker containers by issuing docker CLI commands;
- **containerd** - a daemon that listens to the user commands, it controls the container lifecycle: pulls images, manages networking, uses runc to run containers;
- **runc** - a **low level** **container runtime** that does the **low level stuff** to **create** and **run** *containerised processes*;

<br>

# Podman
**Podman** is a container runtimes. It is **daemonless** and **rootless** (better security, RHEL default).<br>

<br>

# OCI
The **Open Container Initiative** (**OCI**) is an open project under the Linux Foundation created in June 2015.<br>

<br>

The *OCI* established **standards for containers**. Currently, the *OCI* issued **3 specifications**:
- **Image spec** - defines how to package images, last version: **v1.1.1**;
- **Runtime spec** - defines how to run containers from images, last version: **v1.3.0**;
- **Distribution spec**, last version: **v1.1.1**;

<br>

**OCI-compliant image** is an *image* that satisfies *OCI Image spec*.<br>
**OCI-compliant runtime** is an *runtime* that satisfies *OCI Runtime spec*.<br>

<br>

# Container runtime
A **container runtime** is the software responsible for running containers, including pulling images, setting up namespaces, managing storage, and starting processes. It consists of two layers that work together:
- **high-Level runtimes**: **containerd**, **CRI-O**;
  - they handle **image management**, **networking**, **firewalling**;
- **low-level runtimes**: **runc**;
  - **low-level runtimes** do the **low level stuff** to **run** *containerised processes*:
    - creating Linux **namespaces**
    - setting up **cgroups**
    - **spawning processes** inside containers;

<br>

## containerd
In March **2017**, Docker pulled its core container runtime into a standalone project called **containerd** and donated it to the **Cloud Native Computing Foundation** (**CNCF**). So, the **runc** is also decoupled from Docker, because it was part of **containerd**.<br>
By February **2019**, **containerd** had reached the Graduated **maturity level** within the CNCF, representing its significant development, adoption, and community support. Today, developers recognize containerd as an industry-standard container runtime known for its scalability, performance, and stability.<br>

<br>

The **containerd** delegates running the container to **runc** using a **shim process** called **containerd-shim**.<br>

<br>

# Kubernetes and CRI
**CRI** (**Container Runtime Interface**) is an **intefface** between *Kubernetes* and **container runtime**, which allows *Kubernetes* to communicate with **different** *container runtimes*.<br>

The **kubelet** is the **node agent** that runs on each node. The **kubelet** does not communicate with containers directly, but communicates with container runtimes through the **Container Runtime Interface** (**CRI**).<br>

The **execution chain** is: `Kubernetes` → `CRI` → `high-level runtime` → `low-level runtime`.<br>

<br>

Historically, *Kubernetes* shipped with **dockershim**, Because *Docker Engine* does **not** implement **CRI**.<br>
The **dockershim** is a lightweight adapter that allowed *Kubernetes* to interact with the docker engine.<br>
However, **dockershim** was **deprecated** in *Kubernetes* **v1.24**. As of version **v1.23**, *Kubernetes* requires runtimes to be **CRI compatible**.<br>

The **CRI-O** is an **OCI-compatible native implementation** of the **CRI** for Kubernetes.<br>
But with the **CRI compatibility plugin** called **cri-containerd**, Kubernetes can communicate with Docker via **containerd**.<br>

<br>

**cri-containerd** vs. **cri-containerd**:<br>
![CRI](/img/CRI.png)

<br>
