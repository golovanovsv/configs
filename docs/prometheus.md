
label_replace(<vector>, "<target label>", "<content>", "<source label>", "<regexp>")
Можно использовать несколько раз label_replace(label_replace(...), ...)

topk(<num>, <vector>)

rate vs irate vs delta


rate - среднее значение по всему диапазону, используется с counters
irate - мгновенная разница на основании двух последних отсчетов
idelta - разница между последними двумя значениями вектора, используется с типом gauge
delta - разница между первым и последним значением вектора, используется с типом gauge
