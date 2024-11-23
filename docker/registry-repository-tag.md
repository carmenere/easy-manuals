# Registry. Repository. Tag
**Registry** (**Реестр**) – **сервис**, ответственный за хостинг **docker images**.<br>

Для загрузки в реестр и скачивания из **реестра** используются команды `docker push` и `docker pull` соответственно. В реестр можно пушить репозиторий целиком (со всеми образами внутри) или отдельный конкретный **image**.<br>

**Repository** (**Репозиторий**) (aka **image name**) – **коллекция связанных images**, имеющих **одинаковое** *имя*, но **разные** *тэги*.<br>

**Tag** – алфавитно-цифровой идентификатор **image**, часто используется в качестве **версии**, например, **14.04**.<br>

<br>

**Формат полного имени image**:
- **REGISTRY**[:**PORT**]/[**r**|**_**]/**NAMESPACE**/**REPO**[:**TAG**]

где:
- **REGISTRY** – **доменное** имя **реестра**;
- [**r**|**_**] – тип namespace: **_** - корневой namespace; **r** - пользовательский namespace;
- **NAMESPACE** – общим соглашением является использование **логина пользователя** в реестре в качестве **NAMESPACE**;
- **REPO** – **репозиторий** (**image name**);
- **TAG** – **image version** в репозитории;

<br>

**REPO**[:**TAG**] – определяет конкретный **image** в репозитории.<br>

<br>

**Docker Hub** – является реестром по умолчанию.<br>

- `docker pull nginx:[tag]` скачает **image** из namespace типа _ из репозитария nginx из реестра **Docker Hub**: `https://hub.docker.com/_/nginx/`;
- `docker pull bitnami/nginx:[tag]` скачает **image** из namespace bitnami типа r из репозитария nginx из реестра **Docker Hub**: `https://hub.docker.com/r/bitnami/nginx/`;

Если перед **NAMESPACE** явно указать **hostname**[:**port**], то будет использоваться реестр, отличный от **Docker Hub**.<br>
