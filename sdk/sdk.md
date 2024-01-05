# SDK
A **software development kit** (**SDK**) is a **collection of software development tools** in one installable package.<br>
They facilitate the creation of applications by having a **compiler**, **debugger**, etc.<br>
They are normally **specific** to a **hardware platform** and **operating system** combination.<br>

<br>

# JDK
**JDK** (**Java Development Kit**) is a **set of tools** for developing Java applications.<br>
The **JDK** is a **distribution** of **Java technology**.<br>

`JDK = JRE + Development tools`

<br>

`JRE = JVM + Standard libraries`

<br>

- **JVM** is an abbreviation for **Java Virtual Machine**. **JVM** actually runs Java **bytecode**, and it uses the **libraries**, and other **files** provided in **JRE**.
- **JRE** is an abbreviation for **Java Runtime Environment**. **JRE** contains **JVM**, **libraries**, and other **supporting files**. It **doesn't** contain any development tools such as *compiler*, *debugger*, etc.

<br>

If you want to **run any Java program**, you need to have **JRE** installed in the system.

<br>

**Development tools**:
- **javac** – the **Java compiler**, which converts source code into Java bytecode.
- **jar** – the **archiver**, which packages related class libraries into a **single JAR file**.
- **javadoc** – the **documentation generator**, which automatically generates documentation from source code comments.
- **jdb** – the **debugger**.
- **java** – the **loader** for Java apps.

<br>

## Extensions
- files with extension `.java` contain **source code**;
- files with extension `.class` contain **bytecode**;

<br>

# Java Platform
The **Java platform** is a **suite of programs** that facilitate **developing** and **running** programs written in the **Java programming language**.<br>

There are 2 different JDKs:
- **Java SE** (Java platform, Standard Edition). **Java SE** is the **standard version of Java** that most developers use for writing **web applications**, **desktop applications**, and other software projects.
- **Java EE** (Java platform, Enterprise Edition). **Java EE** extends *Java SE* and provide some extra features such as **clustering capabilities** for large-scale deployments or **support for advanced hardware like GPUs**.

<br>

# OpenJDK
**OpenJDK** is a free and open-source (**FOSS**) implementation of the **Java SE**.<br>
**OpenJDK** versions are bound to **Java SE**.<br>
**OpenJDK** and **Java SE** are **interchangeable**.