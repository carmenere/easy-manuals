# Table of contents
<!-- TOC -->
- [Table of contents](#table-of-contents)
- [Locale](#locale)
  - [C locale](#c-locale)
  - [Locale environment variables](#locale-environment-variables)
  - [Relationship between variables `LANG`, `LANGUAGE`, `LC_ALL` and `LC_xxx`](#relationship-between-variables-lang-language-lc_all-and-lc_xxx)
- [The `locale` command](#the-locale-command)
  - [Examples](#examples)
    - [`locale`](#locale-1)
    - [`locale -k LC_TIME`](#locale--k-lc_time)
    - [`locale -a`](#locale--a)
- [Lexicographical sorting vs. natural sorting](#lexicographical-sorting-vs-natural-sorting)
  - [Examples](#examples-1)
- [Collation](#collation)
<!-- TOC -->

<br>

# Locale
A **locale** is a **set of language and cultural rules**.<br>
These *rules* are **divided** into *groups* aka **locale categories** or just **categories**.<br>
Each *locale category* *controls* a **specific aspect** of a locale, such as **date and time** formats, **monetary** formats and so on.<br>

<br>

A **name of locale** has a format: `language_COUNTRY.encoding` or `language-COUNTRY.encoding`, the `.encoding` is **optional**:
- `language` is the **language code**;
- `COUNTRY` is the **country code**;

**Interpretation**:
- `sv_SE` means **Swedish** (`sv`) as spoken in **Sweden** (`SE`);
- `en_US` means **English** (`en`) as spoken in **USA** (`US`);

**Examples**:
- the **locale** `en_US.UTF-8` has **3 parts**: `en` is the **language code**, and `US` is the **country code** and **encoding** `UTF-8`;
- the **locale** `en_US` has **2 parts**: `en` is the **language code**, and `US` is the **country code**;



<br>

There are **different locale categories**:
- **defined by POSIX**:
  - `LC_CTYPE`
    - determines the rules governing:
      - the **character classes**
        - What is a **letter**?
        - What is a **digit**?
        - What is a **whitespace**?
        - Is it a **punctuation mark**? (/ˌpʌŋk.tʃuˈeɪ.ʃən/)
      - the **case conversion**;
        - Is it **upper-case** or **lower-case**?
      - the **interpretation of byte sequences as characters** (**single-byte** or **multibyte characters**);
  - `LC_COLLATE`
    - determines the rules governing the behavior of **string comparison** and **sorting**;
  - `LC_MONETARY`
    - determines the rules governing **currency formatting**, including the **currency symbol**;
  - `LC_NUMERIC`
    - determines the rules governing **non-monetary numbers formatting**;
  - `LC_TIME`
    - determines the rules governing **date and time formatting**;
  - `LC_MESSAGES`
    - determines in which language a user sees **error messages**, **prompts**, and other **interface text**;
    - **example**:
      -  in the case of the PostgreSQL server the `LC_MESSAGES` determines the **language of server-generated messages**, in other words, the messages that are emitted by the PostgreSQL **server itself**;
      - **client applications** with multilingual support such as **psql** configure their output based on the the **variables** in their **local environment**, e.g `LANG`, `LC_MESSAGES` or `LC_ALL`;
  - `LC_ALL`
    - it is **special category**;
    - **overrides** all the other localisation settings:
      - the values of `LANG` environment variable and the values of any other `LC_xxx` environment variables;
- **nonstandard** categories (supported by **libc**, since glibc 2.2):
  - `LC_ADDRESS`
    - change settings that describe the formats used to describe **locations** and **geography-related items**, e.g., postal addresses;
  - `LC_IDENTIFICATION`
    - **stores metadata about the locale itself**, such as its name and version;
  - `LC_MEASUREMENT`
    - determines the rules governing **measurement units formatting**;
  - `LC_NAME`
    - change settings that describe the **formats used to address persons**;
  - `LC_PAPER`
    - change the settings relating to the **dimensions of the standard paper size** (e.g., **A4**);
  - `LC_TELEPHONE`
    - change settings that describe the **formats to be used with telephone services**;

<br>

Each category has a number of settings (aka keywords) for example, **date_fmt** or **decimal_point** and so on.<br>
The `locale -k LC_TIME` command shows a list of **all keywords** for appropriate category (more details below).<br>

<br>

The **locale providers**:
- **built in the application**: this is **built-in** collation support, it is **OS agnostic**;
- **system library provider**: for example, **glibc**, it is **OS dependent**;
- **ICU provider**, **International Components for Unicode**: uses **ICU library**;

<br>

## C locale
The **C locale** is a **special locale** that is meant to be the **simplest locale**.<br>
In the **C locale**:
- **characters are single bytes**;
- the **charset is ASCII**;
- the **sorting order** is based on the **code point values** (**byte values**);
- the **language** is usually **US English**;
- and things like _currency symbols_ are **not defined**;

<br>

## Locale environment variables
Each *locale category* can be **configured independently** by appropriate **locale environment variable** (aka `LC_xxx`).<br>
The *locale environment variables* **have the same names** as the *locale categories*.<br>
The **locale environment variables** tell the OS **how to display** certain kinds of text or **specific aspect** of a locale.<br>

Each **locale environment variables** sets the **name of locale** for appropriate **category**: `<NAME-OF-VAR>=<name-of-locale>`.<br>

|Category|Variable|
|:-------|:-------|
|**LC_COLLATE**|`LC_COLLATE=<locale>`|
|**LC_CTYPE**|`LC_CTYPE=<locale>`|
|**LC_MONETARY**|`LC_MONETARY=<locale>`|
|**LC_NUMERIC**|`LC_NUMERIC=<locale>`|
|**LC_TIME**|`LC_TIME=<locale>`|
|**LC_MESSAGES**|`LC_MESSAGES=<locale>`|
|**LC_ALL**|`LC_ALL=<locale>`|
|**LC_ADDRESS**|`LC_ADDRESS=<locale>`|
|**LC_IDENTIFICATION**|`LC_IDENTIFICATION=<locale>`|
|**LC_MEASUREMENT**|`LC_MEASUREMENT=<locale>`|
|**LC_NAME**|`LC_NAME=<locale>`|
|**LC_PAPER**|`LC_PAPER=<locale>`|
|**LC_TELEPHONE**|`LC_TELEPHONE=<locale>`|

<br>

## Relationship between variables `LANG`, `LANGUAGE`, `LC_ALL` and `LC_xxx`
The **locale environment variables** are prioritized:
- `LC_ALL` has the **highest precedence** and overrides all other locale variables;
- if `LC_ALL` is **not** set, then **individual** `LC_xxx` variables are used;
- `LANG` is used as the **default** for any `LC_xxx` variables that are **not explicitly set**;

<br>

The variable `LANGUAGE` operates **independently** for message translation within GNU applications.<br>
Not all programs have translations for all languages. If you understand other languages, you can set up a priority list of languages. This is done through a variable, called `LANGUAGE`.<br>

<br>

For example, consider that
- the **primary language** is set to `sv_SE`: `LANG=sv_SE` (or `LC_ALL=sv_SE`);
- the `LANGUAGE` is set to `sv:de`;

It means when **Swedish** is **not available**, the text will be translated to **German** (`de`) than **English** (**by default**, an **English** message is shown in place of a nonexistent translation);

<br>

# The `locale` command
The **locale** command displays information about the **current locale**.

**Commands**:
- `locale`
  - displays list of all **locale environment variables** that are **set**;
- `locale -a`
  - displays a list of all *available* **locales**;
- `locale -m`
  - displays a list of all *available* **charmaps**;
- `locale -k LC_TIME` shows a list of all *available* **keywords** for appropriate category (only **POSIX categories** are available for `-k` option);

<br>

## Examples
### `locale`
```bash
locale
LANG=en_US.UTF-8
LANGUAGE=en_US
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC=ro_RO.UTF-8
LC_TIME=ro_RO.UTF-8
LC_COLLATE="en_US.UTF-8"
LC_MONETARY=ro_RO.UTF-8
LC_MESSAGES="en_US.UTF-8"
LC_PAPER=ro_RO.UTF-8
LC_NAME=ro_RO.UTF-8
LC_ADDRESS=ro_RO.UTF-8
LC_TELEPHONE=ro_RO.UTF-8
LC_MEASUREMENT=ro_RO.UTF-8
LC_IDENTIFICATION=ro_RO.UTF-8
LC_ALL=
```

<br>

### `locale -k LC_TIME`
```bash
locale -k LC_TIME
ab_day="Sun";"Mon";"Tue";"Wed";"Thu";"Fri";"Sat"
abday="Sun";"Mon";"Tue";"Wed";"Thu";"Fri";"Sat"
day="Sunday";"Monday";"Tuesday";"Wednesday";"Thursday";"Friday";"Saturday"
abmon="Jan";"Feb";"Mar";"Apr";"May";"Jun";"Jul";"Aug";"Sep";"Oct";"Nov";"Dec"
mon="January";"February";"March";"April";"May";"June";"July";"August";"September";"October";"November";"December"
am_pm="AM";"PM"
t_fmt_ampm="%I:%M:%S %p"
era=""
era_d_fmt=""
era_t_fmt=""
era_d_t_fmt=""
alt_digits=""
d_t_fmt="%a %b %e %X %Y"
d_fmt="%m/%d/%Y"
t_fmt="%H:%M:%S"
```

<br>

### `locale -a`
```bash
locale -a
fa_IR
ca_AD.UTF-8
en_NZ
en_SG.ISO8859-1
nl_NL.UTF-8
lv_LV.UTF-8
pt_BR.UTF-8
ca_FR.ISO8859-15
fr_CH.ISO8859-15
eu_ES.ISO8859-15
en_US.US-ASCII
af_ZA
bg_BG
en_IE.ISO8859-1
en_HK
es_MX.UTF-8
cs_CZ.UTF-8
fi_FI
zh_CN.UTF-8
eu_ES
sk_SK.ISO8859-2
nl_BE
fr_BE
sv_FI.UTF-8
sk_SK
se_NO.UTF-8
en_US.UTF-8
nb_NO.ISO8859-15
en_NZ.ISO8859-1
de_CH
sk_SK.UTF-8
de_DE.UTF-8
am_ET.UTF-8
zh_HK
be_BY.UTF-8
uk_UA
pt_PT.ISO8859-1
en_AU.US-ASCII
kk_KZ.PT154
en_US
en_ZA.UTF-8
ca_IT
nl_BE.ISO8859-15
fa_IR.UTF-8
de_AT.ISO8859-1
hr_HR.ISO8859-2
fr_FR.ISO8859-1
af_ZA.UTF-8
am_ET
sv_FI.ISO8859-1
fi_FI.ISO8859-1
ro_RO.UTF-8
ar_AE
af_ZA.ISO8859-15
en_NZ.UTF-8
fi_FI.UTF-8
hi_IN.UTF-8
C.UTF-8
hr_HR.UTF-8
da_DK.UTF-8
ca_ES.ISO8859-1
en_AU.ISO8859-15
ro_RO.ISO8859-2
de_AT.UTF-8
pt_PT.ISO8859-15
sv_SE
fr_CA.ISO8859-1
fr_BE.ISO8859-1
en_US.ISO8859-15
it_CH.ISO8859-1
en_NZ.ISO8859-15
en_AU.UTF-8
ar_MA
lv_LV.ISO8859-13
de_AT.ISO8859-15
af_ZA.ISO8859-1
hu_HU.UTF-8
ca_AD.ISO8859-1
et_EE.UTF-8
es_AR.ISO8859-1
he_IL.UTF-8
uk_UA.KOI8-U
uk_UA.CP1251
be_BY
kk_KZ
hu_HU.ISO8859-2
it_CH
pt_BR
ko_KR
it_IT
fr_BE.UTF-8
ru_RU.ISO8859-5
et_EE.ISO8859-1
se_FI.UTF-8
zh_TW
es_CR
sr_RS
nb_NO
zh_CN.GB2312
no_NO.ISO8859-15
ar_JO
sv_FI.ISO8859-15
ca_AD
de_DE.ISO8859-15
en_IN.UTF-8
en_CA
fr_CH.UTF-8
sl_SI.UTF-8
uk_UA.ISO8859-5
pt_PT
hr_HR
cs_CZ
ca_FR.UTF-8
fr_CH
he_IL
en_HK.ISO8859-1
zh_CN.GBK
zh_CN.GB18030
fr_CA
en_IE.ISO8859-15
pl_PL.UTF-8
ja_JP.SJIS
hi_IN
sr_YU.ISO8859-5
be_BY.CP1251
sr_YU.ISO8859-2
sv_SE.UTF-8
se_NO
sr_YU.UTF-8
de_CH.UTF-8
sl_SI
ar_QA
en_IN
pt_PT.UTF-8
ro_RO
en_NZ.US-ASCII
ja_JP
zh_CN
fr_CH.ISO8859-1
ko_KR.eucKR
nn_NO.ISO8859-1
be_BY.ISO8859-5
nl_NL.ISO8859-15
en_GB.ISO8859-1
en_CA.US-ASCII
nb_NO.UTF-8
ca_FR.ISO8859-1
is_IS.ISO8859-1
ru_RU.CP866
nl_NL
ca_IT.ISO8859-15
se_FI
fr_CA.ISO8859-15
sv_SE.ISO8859-15
hy_AM
es_MX.ISO8859-1
ar_JO.UTF-8
en_CA.ISO8859-15
en_US.ISO8859-1
zh_TW.Big5
ca_ES.UTF-8
ru_RU.CP1251
en_GB.UTF-8
ar_AE.UTF-8
sr_RS.ISO8859-5
en_GB.US-ASCII
ru_RU.UTF-8
sr_RS.UTF-8
eu_ES.UTF-8
es_ES.ISO8859-1
hu_HU
el_GR.ISO8859-7
en_AU
ar_SA
it_CH.UTF-8
en_GB
sl_SI.ISO8859-2
ru_RU.KOI8-R
ga_IE.UTF-8
ga_IE
nl_BE.UTF-8
et_EE
fr_FR.ISO8859-15
cs_CZ.ISO8859-2
es_MX
lt_LT.UTF-8
en_ZA
pl_PL.ISO8859-2
fr_BE.ISO8859-15
is_IS.UTF-8
tr_TR.ISO8859-9
da_DK.ISO8859-1
en_HK.UTF-8
en_ZA.ISO8859-1
lt_LT.ISO8859-4
lt_LT.ISO8859-13
en_SG
zh_TW.UTF-8
bg_BG.CP1251
el_GR.UTF-8
en_PH
be_BY.CP1131
ar_MA.UTF-8
da_DK.ISO8859-15
is_IS.ISO8859-15
no_NO.ISO8859-1
nl_NL.ISO8859-1
nl_BE.ISO8859-1
sv_SE.ISO8859-1
lv_LV
pt_BR.ISO8859-1
es_AR
zh_CN.eucCN
it_IT.UTF-8
en_CA.UTF-8
uk_UA.UTF-8
nn_NO.ISO8859-15
de_CH.ISO8859-15
ca_FR
de_DE.ISO8859-1
ca_ES
sr_YU
hy_AM.ARMSCII-8
ru_RU
zh_HK.UTF-8
eu_ES.ISO8859-1
is_IS
bg_BG.UTF-8
ja_JP.UTF-8
ar_EG
it_CH.ISO8859-15
fr_FR.UTF-8
mn_MN.UTF-8
mn_MN
ko_KR.UTF-8
et_EE.ISO8859-15
ar_QA.UTF-8
es_AR.UTF-8
nn_NO
en_ZA.ISO8859-15
kk_KZ.UTF-8
ca_ES.ISO8859-15
en_IE.UTF-8
ca_AD.ISO8859-15
es_ES
de_CH.ISO8859-1
nb_NO.ISO8859-1
en_ZA.US-ASCII
en_CA.ISO8859-1
es_ES.ISO8859-15
en_AU.ISO8859-1
el_GR
da_DK
no_NO
ar_EG.UTF-8
ca_IT.UTF-8
it_IT.ISO8859-1
en_IE
zh_HK.Big5HKSCS
hi_IN.ISCII-DEV
ja_JP.eucJP
it_IT.ISO8859-15
pl_PL
ko_KR.CP949
en_PH.UTF-8
fr_CA.UTF-8
fi_FI.ISO8859-15
en_GB.ISO8859-15
fr_FR
hy_AM.UTF-8
no_NO.UTF-8
nn_NO.UTF-8
ca_IT.ISO8859-1
es_ES.UTF-8
en_SG.UTF-8
de_AT
sv_FI
tr_TR.UTF-8
fa_AF
de_DE
ar_SA.UTF-8
lt_LT
es_CR.UTF-8
fa_AF.UTF-8
tr_TR
sr_RS.UTF-8@latin
C
POSIX
```

<br>

# Lexicographical sorting vs. natural sorting
There 2 types of sorting:
- **lexicographical sorting** (/ˌlɛksɪˈkɒɡrəfɪk(ə)l/) or **alphanumerical sorting**  (/ˌælfən(j)uˈmɛrɪk(ə)l/);
- **natural sorting**;

<br>

## Examples
The **natural sort**:
```bash
z2
z11
```
because the number `2` is **numerically smaller than** `11`.<br>

<br>

The **lexicographical sort**/**alphanumerical sorting**:
```bash
z11
z2
```
because `1` is **lexicographically smaller than** `2`.<br>

<br>

# Collation
**Collation** is a **set of rules** used for **sorting** and **comparison properties**.<br>

Usually **code point values** are **used** as a **default collation** - `A` with code point `65` is **before** `a` with code point `97`.<br>
**Sort algorithm** using **different** collations can produce **different** result for the **same** input strings.<br>

**Example 1**: What is correct?<br>
1. 
```bash
a.b
a.c
ad
ae
a.f
a.g
```

**OR**

2. 
```bash
a.b
a.c
a.f
a.g
ad
ae
```

<br>

**Example 2**: What is correct?<br>
1. 
```bash
#
$
@
^
&
```

**OR**

2. 
```bash
@
&
#
^
$
```
