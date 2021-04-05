# Пруфы:
# https://www.youtube.com/watch?v=kKigibHrV5I

# Мониторинг напрямую черех JMX

Состав памяти Java:
  - JavaHeap
  - GC
  - Class Loading (Class + Metaspace)
  - JIT compilation (Code + Compiler)
  - Threads

-XX:NativeMemoryTracking=[summary|detail] # минус 5-10% производительности

jcmd <PID> VM.native_memory [detail]
  - committed - реальной памяти
  - mmap - выделено ОС
  - malloc - выделено JVM

# Включение G1 GC
-XX:+UseG1GC

# Размер Heap
-Xmx - максимальный размер JavaHeap
-Xms - начальный размер JavaHeap
-XX:+AlwaysPreTouch - выделить весь -Xmx сразу
-XX:-AdaptiveSizePolicy - не адаптировать размер JavaHeap
-XX:MinHeapFreeRatio=40
-XX:MaxHeapFreeRation=70

# Размер metaspace
-XX:MetaspaceSize=20M  # Флаг срабатывания FullGC
-XX:MaxMetaspaceSize=[unlimited]
-XX:CompressedClassSpaceSize=1G
-XX:MinMetaspaceFreeRation=40
-XX:MaxMetaspaceFreeRation=70
-XX:+UnlockDiagnosticVMOptions   # enabled GC.class_stat
-XX:+PrintGCDetails

# Размер JIT
# Если размер CodeCache слишком мал, то jvm будет постоянно выполнять перекомпиляцию
#  местрика CodeCacheUsed
-XX:InitialCodeCacheSize
-XX:ReservedCodeCacheSize

# Размер Treads
#  Включает стек потока (Примерно 100-150 Kb на поток)
-Xss # Thread stack  size
-XX:VMThreadStackSize
-XX:CompiletThreadStackSize

# Размер internal (Off-heap + FileMaps + Direct ByteBuffers)
-XX:MaxDirectMemorySize=[Xmx]
-XX:+DisableExplicitGC  # Перестает очищаться internal
-XX:+ExplicitGCInvokesConcurrent

# Общие параметры
-XX:+UseLargePages
-Xlog:gc+heap  # Must have для прода :/
-XX:MaxRam # JVM видит столько памяти, влияет только на -Mmx если он не задан явно

GC - занимает до 10% кучи сверху

Статистика ClassLoader
pmap -x <PID>
jmap -clstats <PID>             # JDK 8
jcmd <PID> VM.classloader_stats # JDK 9+
jcmd <PID> VM.metaspace         # JDK 9+
jcmd <PID> GC.class_stat        # Нужен флаг -XX:+UnlockDiagnosticVMOptions
jcmd <PID> VM.stringtable
jcmd <PID> VM.symboltable

Сборщики мусора:
 - Parallel - не отдает committed память
 - CMS - отдает, но не сразу
 - G1 - отдает сразу
