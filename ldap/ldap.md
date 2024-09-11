# DN and RDN
Data is represented in an **LDAP** system as a hierarchy of objects, each of which is called an **entry**. The resulting tree structure is called a **Directory Information Tree** (**DIT**).<br>

A **DN** (*distinguished name*) is a **sequence of RDN** (*Relative DN*) connected by commas. So, **DN** uniquely identifies each entry in **DIT**.<br>

An **RDN** is an **attribute** with an associated **value** in the form `attribute=value` normally expressed in a UTF-8 string format.<br>

<br>

Example of **DN**:
```
CN=Jeff Smith,OU=Sales,DC=example,DC=COM
```

<br>

Typical **RDN** attributes:
|RDN attribute|Meaning|
|:--------|:------|
|**C**|Country name, this contains a two-letter **ISO 3166** country code.|
|**CN**|Common name, this contains name of the **object** (person's name; meeting room; recipe name; job title; etc.).|
|**DC**|Domain component, this refers to each component of the domain.|
|**L**|Locality name, contains names of a **locality** or **place**, such as a **city**, **county**, or other **geographic region**.|
|**O**|Organization name, contains the name of an organization.|
|**OU**|Organizational unit name, this refers to the organisational unit (or sometimes the user group) that the user is part of.|
|**SN**|Surname of person.|
|**ST**|State or province name, contains the full names of **states** or **provinces**.|
|**STREET**|Street address, contains the postal address.|
|**UID**|User ID|
