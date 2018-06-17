# Lab04 Lock Manager Simulator

本实验要求实现一个支持S锁、X锁的锁管理器模拟程序。完整的锁管理器实现须依赖事务、事务管理以及并发控制的实现，因而过于复杂。在本实验中，我们模拟实现一个简单的锁管理器。该锁管理器从stdin获取事务的锁请求（实际中应来自事务管理子系统以及并发控制子系统），然后将事务的锁信息输出到stdout。

输入命令的格式为：<request type> <transaction ID> <object>

其中<request type>是锁管理器接收的处理请求。本实验要求模拟S锁和X锁（其它锁类型可以自行扩充），因此输入命令至少包括Start、End、XLock、SLock、Unlock等五种命令，分别表示开始事务、结束事务(abort or commit)、请求X锁、请求S锁、释放锁。<transaction ID>是事务标识，我们规定其为0到255之间的一个整数；<object>是请求加锁的数据库对象，以单个的大写字母来表示。

以下是几种可能的输入命令例子：

1. Start transID: 开始一个事务transID.
2. End transID: 结束事务transID。此时需要释放该事务所持有的所有锁。如果有别的事务在等待transID上的锁，则需要根据给定的策略将锁授予等待的事务。
3. SLock transID object: 事务transID请求object上的一个S锁。该请求可能的输出有两种：如果锁请求被批准，则更新锁表信息同时输出“Lock granted”；如果锁请求不能被批准，则将该事务放入等待队列并输出“Waiting for lock (X-lock held by: <trans_ID>)”。
4. XLock transID object: 事务transID请求object上的一个X锁。该请求同样有两种可能的执行结果，即批准或者等待。如果事务之前已经持有了object上的S锁，则该操作将S锁升级为X锁。
5. Unlock transID object: 事务transID释放对象object上的锁。释放锁之后，如果有别的事务在等待该锁，则需要将锁按给定的策略授予等待的事务。你可以自定义等待事务获得锁的规则，例如FIFO、LIFO等，但需要在实验报告中明确解释你的规则。

每种输入命令有相应的输出信息。下表给出了每一种输入命令可能的输出信息：