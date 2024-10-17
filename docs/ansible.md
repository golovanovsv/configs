
Перечень фактов:
ansible all -i 'localhost,' -m setup -a 'filter=ansible_pkg_mgr'

Сравнение версий
kuber_version is version('1.9', '<')

Вытаскивание элемента словаря из массива словарей:
list[dicts] | map(attribute='element') | list

Слепить массив массивов их 2х массивов
[1, 2] | zip([a, b]) = [ [1, a], [2, b] ]

Собрать группу по ключу
- group_by:
    key: "{{ group_id|default('noGroup') }}"

Не выводить чувствительные данные
- name: "Set password"
  set_fact: ...
  no_log: true

### vars
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
```
# role: www
# role: app
- group_by:
    key: role | default("other")
```

Создаст группы www и app

### hostvars

Модуль `set_fact` добавляет переменные в структуру hostvars.
Поэтому к переменным одного севрера можно обращать с другого сервера.
