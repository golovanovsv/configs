# Ansible

Перечень фактов:
ansible all -i 'localhost,' -m setup -a 'filter=ansible_pkg_mgr'

Сравнение версий
kuber_version is version('1.9', '<')

Вытаскивание элемента словаря из массива словарей:
list[dicts] | map(attribute='element') | list

Слепить массив массивов их 2х массивов
[1, 2] | zip([a, b]) = [ [1, a], [2, b] ]

Собрать группу по ключу

```yaml
- group_by:
    key: "{{ group_id|default('noGroup') }}"
```

Не выводить чувствительные данные

```yaml
- name: "Set password"
  set_fact: ...
  no_log: true
```

## vars

ansible_all_ipv4_addresses
ansible_default_ipv4.address
ansible_pkg_mgr: systemd|upstart|...
ansible_os_family: RedHat|Debian
ansible_distribution: OracleLinux|Ubuntu
ansible_distribution_major_version:
ansible_distribution_version: "16.04"
ansible_lsb:
  codename:
  description:
  id:
  major_release:
  release:

ansible_hostname: hostname from facts

### Динамические группы по ключу

Модуль group_by создает группы по имени указанного ключа (key).

```yaml
# role: www
# role: app
- group_by:
    key: role | default("other")
```

Создаст группы www и app

### hostvars

Модуль `set_fact` добавляет переменные в структуру hostvars.
Поэтому к переменным одного севрера можно обращать с другого сервера.

### Как собрать массив в set_fact

```yaml
  - set_fact:
      instance:
        name: "{{ ansible_nodename }}"
        os: "{{ ansible_distribution + ' (' + ansible_distribution_version + ')' }}"
        cpus: "{{ ansible_facts.processor_vcpus }}"
        memory: "{{ (ansible_memtotal_mb / 1024) | round }}"
        disks: >
          {{
            dict(
              ansible_devices
              | dict2items
              | selectattr('value.vendor', 'equalto', 'ATA')
              | map(attribute='key')
              | zip(
                  ansible_devices
                  | dict2items
                  | selectattr('value.vendor', 'equalto', 'ATA')
                  | map(attribute='value.size')
                )
            )
          }}
      instance2: >
        {{ {
          "name": ansible_nodename,
          "os": ansible_distribution + " (" + ansible_distribution_version + ")",
          "cpus": ansible_facts.processor_vcpus,
          "memory": (ansible_memtotal_mb / 1024) | round
        } }}
```

### Как фильтровать массивы словарей

```yaml
mounts:
  - mount: /
    fstype: ext4
    device: /dev/sda2
  - mount: /data
    fstype: xfs
    device: /data/sdb
```

Чтобы выбрать все элементы массива с типом fs = extfs:

`{{ mounts | selectattr('fstype', 'equalto', 'xfs') }}`:

```yaml
mounts:
  - mount: /data
    fstype: xfs
    device: /data/sdb
```

Чтобы получить все варианты значений поля fstype:

`{{ ansible_mounts | map(attribute='fstype') }}`:

```yaml
mounts:
  - ext4
  - xfs
```

### Форматирование строк

`{{ "Name: %s" | format(name) }}` - используется форматирование с [printf-style](https://docs.python.org/3/library/stdtypes.html#printf-style-string-formatting)
