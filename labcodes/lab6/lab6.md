# 实验六：调度器

## 练习一

## 练习二

### stride_init

* 初始化指向就绪进程的指针
* 初始化就绪进程数为0

### stride_enqueue

* 检查proc->run_link，保证为空
* 检查rq->lab6_run_pool是否为NULL
    * 若为NULL，则初始化proc->run_link，并将rq->lab6_run_pool指向它
    * 否则，调用skew_heap_insert将其插入斜堆
* 若进程已无时间片或者时间片数大于允许的最大值，则将其设为rq->max_time_slice
* 将proc->rq指向rq
* 就绪数加1

### stride_dequeue

* 检查