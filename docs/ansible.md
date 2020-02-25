
Перечень фактов:
ansible -i'localhost,' -msetup all

Сравнение версий
kuber_version is version('1.9', '<')

Вытаскивание элемента словаря из массива словарей:
list[dicts] | map(attribute='element') | list

Слепить массив массивов их 2х массивов
[1, 2] | zip([a, b]) = [ [1, a], [2, b] ]

Собрать группу по ключу
- group_by:
    key: "{{ group_id|default('noGroup') }}"
