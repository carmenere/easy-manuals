# Table of contents
- [Table of contents](#table-of-contents)
- [LDAP](#ldap)
  - [DIT, DN and RDN](#dit-dn-and-rdn)
  - [Examples of entries](#examples-of-entries)
    - [Person entry](#person-entry)
    - [OU entry](#ou-entry)
- [Schema](#schema)
- [MS AD](#ms-ad)

<br>

# LDAP
**LDAP** (*Lightweight Directory Access Protocol*) is a **protocol** used to **query** and **manage** **directory services**.<br>
**Directory service** (or just **directory**) a specialized **hierarchical database**, e.g. **Active Directory**, **OpenLDAP**.<br>

<br>

*Directory service* TCP ports:
- **LDAP** uses TCP port **389**
- **LDAPS** (*LDAP over SSL*) uses TCP port **636**;
 
<br>

**LDIF** (*LDAP Data Interchange Format*) is a standard **plain text format** defined in **RFC 2849** used to represent **LDAP entries** and **update requests** (**add**, **modify**, **delete**).<br>

<br>

A directory entry in LDIF:
```ldif
dn: uid=alice,ou=people,dc=wonderland,dc=net
uid: alice
objectClass: inetorgperson
objectClass: organizationalperson
objectClass: person
objectClass: top
cn: Alice Wonderland
sn: Wonderland
employeeNumber: 18001
givenName: Alice
initials: AA
mail: alice@wonderland.net
mobile: +1 010 154 3228
userPassword:: c2VjcmV0
```

<br>

A LDIF that adds a telephone number to an existing user:
```ldif
dn: cn=Peter Michaels, ou=Artists, l=San Francisco, c=US
changetype: modify
add: telephonenumber
telephonenumber: +1 415 555 0002
```

<br>

## DIT, DN and RDN
An *LDAP directory* stores information in a **tree structure** known as **DIT** (*Directory Information Tree*).<br>
The *nodes* in **DIT** are called **entries**.<br>
**Each entry** in **DIT** has **one** *parent entry* and **zero or more** *child entries*.<br>

<br>

**Each entry** in **DIT** is *composed of* **one** or **more** *objectClasses* which is listed in the *objectClass attribute*.<br>
The **objectClass** is like *type* and the **entry** is like *instance of type*.<br>
The *objectClass attribute* is **always** present in **any entry** and can have **multiple values**.<br>
An *objectClass* has a **name** and contains **zero** or **more** *attributes*.<br>
An *objectClass* defines **mandatory** *attributes* and **optional** *attributes*.<br>
An *objectClass* determines the **set of attributes** that may be present in an entry.<br>
So, **each entry** in **DIT** contains information in `attribute=value` form.<br>

<br>

All *attributes* are members of **one**, or **more**, *objectClasses*. An *attribute* may be **optional** in one *objectClass* and **mandatory** in another.<br>
Some *attributes* may have **multiple values**, others are **restricted** to a **single value**. The **multi-value** means the *attribute* can appear **multiple** times in an *entry* with **different** *data values*.<br>

<br>

The **top of the DIT** is called the **root entry**.<br>
The **RDN** of *root entry* is called the **base DN**, this is like *name of the database* ih PostgreSQL. **All** other entries must come **under** *base DN*.<br>

<br>

**Example of DIT**:<br>
![ldap-dit](/img/ldap-dit.png)

<br>



**Each entry** in **DIT** is **uniquely identified** by its **DN** (*Distinguished Name*).<br>
An **RDN** is an **attribute** with its **value** in the form `attribute=value` normally expressed in a **UTF-8** string format.<br>
In **OpenLDAP** you *can choose any attribute as RDN* that is allowed in the entry.<br>
In Active Directory the *RDN attribute is defined in the appropriate schema* - so you **can't** choose attribute as RDN.<br>
When you have the choice (using OpenLDAP) use a **RDN** that can **uniquely identify** an entry **under the same parent** entry.<br>

An **RDN** (*Relative Distinguished Name*) is a component of the **DN**.<br>
**Multiple attributes** can be combined into **one RDN** with plus signs `+`.<br>
So, **DN** is a **sequence of RDN** (*Relative DN*) connected by commas:
```
RDN,RDN,RDN
```

<br>

Example of **DN**:<br>
![ldap-dn](/img/ldap-dn.webp)

<br>

Example of **multiple attributes** in **one RDN**:<br>
![multibalued-rdn](/img/multibalued-rdn.webp)

<br>

Typical **RDN** attributes:
|RDN attribute|Description|
|:--------|:----------|
|`c`|Contains a **two-letter ISO 3166 country code**|
|`cn`|Contains a **name of an object**. If the object corresponds to a person, it is typically the person's full name.|
|`dc`|Contains domain component, this refers to each component of the domain.|
|`givenName`|Contains a **part of a person's name** which is **not** *surname* **nor** *middle name*.|
|`l`|Contains names of a **locality** or **place**, such as a **city**, **county**, or other **geographic region**.|
|`mail`|Contains a **email address**, which must be given **in full RFC822 format**|
|`o`|Contains name of organisation|
|`ou`|Contains an **organisational unit name** (department/division etc)|
|`sn`|Contains a **surname** (aka **family name**) of a person.|
|`st`|Contains the full names of **state** or **province**.|
|`street`|Contains the postal address.|
|`uid`|Contains a **login name**.|
|`userPassword`|Conatins password of user|

<br>

## Examples of entries
### Person entry
The **set of attributes** for **person entry**:
|Attribute|Mandatory|Notes|
|:--------|:--------|:----|
|`objectClass`|**Y**|`inetOrgPerson` `examplePerson`|
|`uniqueIdentifier`|**Y**||
|`cn`|**Y**||
|`sn`|**Y**||
|`displayName`|**Y**||
|`ou`|**N**||
|`mail`|**N**||
|`personalTitle`|**N**||
|`gn`|**N**||
|`telephoneNumber`|**N**||
|`postalAddress`|**N**||
|`postalCode`|**N**||
|`mobile`|**N**||

<br>

### OU entry
The **set of attributes** for **ou**:
|Attribute|Mandatory|Notes|
|:--------|:--------|:----|
|`displayName`|**Y**||
|`ou`|**Y**||
|`o`|**N**||
|`mail`|**N**||
|`telephoneNumber`|**N**||
|`postalCode`|**N**||

<br>

# Schema
Each *directory* has a **schema**. The **schema** contains **all** *object classes* and *attributes* which can be used by the *LDAP server*.<br>

<br>

# MS AD
Attributes used to **identify**, **authenticate**, and **display** user account information:
|Attribute|Mandatory|
|:--------|:--------|
|`cn`|**Y**|
|`displayName`|**N**|
|`givenName`|**N**|
|`Initials`|**N**|
|`middleName`|**N**|
|`OtherName`|**N**|
|`sAMAccountName`|**Y**|
|`sn`|**N**|
|`userPrincipalName`|**N**|

<br>

The **SAM** (**Security Account Manager**) is a database file in Windows that **stores users' passwords**.<br>
The `sAMAccountName` is **SAM account name**. It is legacy attribute, but it is used for compatibility. The `userPrincipalName` is **preferred** for modern logins.<br>
The `sAMAccountName` must be **unique in the domain**, while `userPrincipalName` must be **unique in the forest**.<br>
