## 基于Harmony OS的图书借阅APP

### 一、API接口
[点击我跳转到Apifox项目API接口](https://apifox.com/apidoc/shared-4c6ce03f-32b2-497f-ae3c-c74c68f3bf0c)
> 需要注意，这里分享的Apifox链接的项目环境是开发环境，即访问地址前置URL是`localhost:8080`，本人租赁的云服务器即将到期，故未提供正式URL。

### 二、后端开发
#### 2.1 项目地址
> 后端技术采用Springboot3+Mybaits实现，有JWT鉴权功能。
[点我跳转到项目地址](https://gitlab.com/xiaolan5691001/book-borrowing)

#### 2.2 数据库语句

建表语句

```sql
-- 创建数据库
drop database if exists book_borrowing;
create database book_borrowing;

-- 使用数据库
use book_borrowing;

-- 用户表
create table user (
    id int unsigned primary key auto_increment comment '主键',
    username varchar(20) not null unique comment '用户名',
    password varchar(32)  comment '密码',
    nickname varchar(10)  default '' comment '昵称',
    email varchar(128) default '' comment '邮箱',
    user_pic varchar(128) default '' comment '头像',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '修改时间'
) comment '用户表';

-- 管理员表
create table admin (
    id int unsigned primary key auto_increment comment '主键',
    admin_name varchar(20) not null unique comment '管理员名',
    admin_pwd varchar(32) comment '管理员密码',
    create_time datetime not null default current_timestamp comment '创建时间'
) comment '管理员表';

-- 图书分类表，应当只有管理员才能创建分类
create table category(
    id int unsigned primary key auto_increment comment '主键',
    category_name varchar(32) not null comment '分类名称',
    create_user int unsigned not null comment '创建人ID',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '修改时间',
    constraint fk_category_user foreign key (create_user) references admin(id) -- 外键约束
) comment  '图书分类表';

-- 书籍表
create table book(
    id int unsigned primary key auto_increment comment '主键',
    title varchar(32) not null comment '书籍名',
    author varchar(20) not null comment '作者',
    isbn varchar(20) not null comment 'ISBN',
    book_content varchar(10000) not null comment '书籍简介',
    book_cover_img varchar(128) not null  comment '书籍封面',
	publisher varchar(50) not null comment '出版社名称',
    available_copies int not null comment '可借阅本数',
    total_copies int not null comment '总本数',
    category_id int unsigned comment '图书分类ID',
    create_user int unsigned not null comment '创建人ID',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '修改时间',
    constraint fk_book_user foreign key (create_user) references admin(id), -- 外键约束
    constraint fk_book_category foreign key (category_id) references category(id) -- 外键约束
) comment '书籍表';

-- 借阅记录表
create table record(
    id int unsigned primary key auto_increment comment '主键',
    user_id int unsigned not null comment '借书人ID',
    book_id int unsigned not null comment '图书ID',
    state boolean default false comment '归还状态: 只能是true 或者 false',
    borrow_time datetime not null default current_timestamp comment '借阅时间',
    return_time datetime comment '归还时间',
    constraint fk_record_user foreign key (user_id) references user(id),
    constraint fk_record_book foreign key (book_id) references book(id)
) comment '借阅记录表';

-- 文章表
create table article(
    id int unsigned primary key auto_increment comment '主键',
    title varchar(30) not null comment '文章标题',
    content varchar(10000) not null comment '文章内容',
    cover_img varchar(128) not null  comment '文章封面',
    -- state varchar(3) default '草稿' comment '文章状态: 只能是[已发布] 或者 [草稿]',
    create_user int unsigned not null comment '创建人ID',
    book_id int unsigned not null comment '图书ID',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '修改时间',
    constraint fk_article_book foreign key (book_id) references book(id),-- 外键约束
    constraint fk_article_user foreign key (create_user) references user(id) -- 外键约束
) comment '文章表';
```
数据插入语句

```sql
-- 使用数据库
USE book_borrowing;

-- user表和admin表的密码字段存储的是MD5字符串，故应当调用API新增。
-- 设admin表中有name:summer,password:123456
-- 设user表中有name:winter,password:123456; name:spring,password:123456

-- 图书分类表数据
-- category_name varchar(32) not null comment '分类名称',
-- create_user int unsigned not null comment '创建人ID',
INSERT INTO category (category_name,create_user) VALUES("青春文学",1); -- id:1
INSERT INTO category (category_name,create_user) VALUES("教辅",1); -- id:2
INSERT INTO category (category_name,create_user) VALUES("外国文学",1); -- id:3
INSERT INTO category (category_name,create_user) VALUES("悬疑小说",1); -- id:4
INSERT INTO category (category_name,create_user) VALUES("漫画",1); -- id:5
INSERT INTO category (category_name,create_user) VALUES("日本文学",1); -- id:6

-- 书籍表数据
-- title varchar(32) not null comment '书籍名',
-- author varchar(20) not null comment '作者',
-- isbn varchar(20) not null comment 'ISBN',
-- book_content varchar(10000) not null comment '书籍简介',
-- book_cover_img varchar(128) not null  comment '书籍封面',
-- publisher varchar(50) not null comment '出版社名称',
-- available_copies int not null comment '可借阅本数',
-- total_copies int not null comment '总本数',
-- category_id int unsigned comment '图书分类ID',
-- create_user int unsigned not null comment '创建人ID',
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("专四语法与词汇1000题","上海外国语大学","978-7-51009-520-7","1.专四语法15类考点系统精讲，附典型专四真题分类训练；
2.总结常用词根词缀与易混词辨析；
3.专四词汇题6大解题技巧归纳；
4.专四语法与词汇45套标准模拟题训练，附详尽解析；
5.专四语法与词汇16堂视频课。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/179360a4-97d2-42d0-87fa-aa720223720c.jpg","世界图书出版公司",10,10,2,1); -- id:1
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("高中数学思想方法导引","张金良","978-7-30823-640-9","本书是以新课标新教材新高考为指导的思想方法工具书，由浙江省11地市名校名师编写，精选高中数学中诸如公式法、配方法、换元法等数学思想方法，每一方法均由方法介绍（特点和作用）、典例示范、巩固练习三个部分组成，其中方法介绍言简意赅，主要阐明了所述方法的内涵、解题对象、适用范围和使用策略；典例示范是精选或自编了难度适中、简洁新颖的典型例题作示范讲解，力求体现上述方法的应用，范例包含思考、解答、反思三部分；巩固练习是所述方法的应用实践，也是典例示范题型分布的一个补充。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/ee97a5bc-8ed4-4c0d-bd92-4e10cbfa79e9.jpg","浙江大学出版社",10,10,2,1); -- id:2
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("专四阅读180篇","上海外国语大学","978-7-51009-518-4","1．专四阅读20篇题源阅读文章＋500核心词汇；
2．专四阅读选择题和简答题2大题型应试技巧；
3．专四阅读60篇分类训练；
4．专四阅读78篇标准模拟集训＋22篇高分冲刺；
5．配套题解本（所有阅读文章均配全文翻译，注释高频词汇，分析长难句）。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/d3ec0d78-2f6c-44d3-a8ae-50e94bac326f.jpg","世界图书出版公司",10,10,2,1); -- id:3
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("铃芽之旅","新海诚","695-5-37179-398-0","17岁的少女铃芽，与姨母一同生活在九州的一座平静的港口小镇上。在某日的上学途中，铃芽和一位美男子擦肩而过，他的目的是“寻找门”，于是铃芽追着他来到了山里的废墟。不过，留在那片废墟之中的是一扇孤零零伫立着的老旧白色之门，而铃芽仿佛被什么吸引了一样，向那扇门伸出了手……联系过去、现在与未来，铃芽的闭门故事就此开启。新海诚导演亲自执笔的原作小说！","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg","新星出版社",10,10,6,1); -- id:4
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("夏天、焰火和我的尸体","乙一","978-7-54429-627-4","夏日的下午六点天还很亮，我和好朋友坐在高高的树上，看着我喜欢的男孩挥着手从森林那头跑来。风抚摩着我的脸颊，周围全是叶子的香气，真好啊！一只温热的小手搭到我背上，我摔了下去，死掉了。男孩跑到树下，对着一动不动的我笑了。“把五月藏起来吧。”他说。我睁着眼睛，看着他们拼命去藏起我的身体，努力不让别人发现。啊！真是辛苦啊，怎么藏也不得安宁。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/24f67196-12b2-486d-a58c-9ba88ae1efac.jpg","南海出版公司",10,10,4,1); -- id:5
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("无名之町","东野圭吾","978-7-54429-790-5","神尾老师死了。
退休前，他是小镇上人人爱戴的老师，亲切又有威信，陪伴许多孩子长大成人。
三周前，神尾老师收到同学们邀请，答应参加他们毕业十五年的同学聚会。
一周前，神尾老师在自家后院被害，尸体被上门拜访的学生发现。
同学聚会当天，在以前上课的教室里，活跃于各行各业的学生们坐在了一起：银行职员、居JIU屋老板、IT公司社长、人气漫画家……
只听哗啦一声，教室的前门开了。
门口站着的，是已经死去的神尾老师。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/ed62c16a-a4af-4ede-83cb-9116f729c0cc.jpg","南海出版公司",10,10,4,1); -- id:6
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("白鸟与蝙蝠","东野圭吾","978-7-57350-305-3","“这一次，我天空里的太阳，将由我亲手熄灭。”
2017年的东京与1984年的爱知交错重叠，对于多年前犯下的罪行，嫌疑人已经供认不讳，然而他的自白却将众人引入更深的迷宫之中。
凶手的儿子与死者的女儿，都对警方的结论心存疑虑，因此暗中联手展开调查，一步步揭开父辈终生隐瞒的秘密。
善与恶，是与非，罪与罚，逻辑与感性……一切看似对立不相容的事物，在巨大的命运齿轮面前立场反转，阴阳颠倒，终于合二为一。“光影共存，昼夜同生，宛如白鸟与蝙蝠在空中对舞。”","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/351a6fcc-379a-4423-966a-d49dfac9f469.jpg","南海出版公司",10,10,4,1); -- id:7
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("又做了，相同的梦","住野夜","978-7-12238-637-3","献给所有当下不顺遂，而想重新来过的人。
奈乃花，自认聪明过人的小学女生，觉得其他同学都是笨蛋，在学校一个朋友都没有的她，总是活在自己的世界里。
每天放学，奈乃花便和她的断尾黑猫朋友散步去拜访﹣﹣住在奶油蛋糕公寓里的“鸡”小姐、住在大木屋里的奶奶，以及在废弃屋顶上的南姐姐。有天，班导师出了一个题目：“幸福，是什么？”
为了寻求答案，奈乃花与因缘际会的三人有了不可思议的历程，然而，她们却不断重复做着相同的梦。
究竟在梦境结束之后，嘴上总挂着口头禅“人生就像OO一样”的奈乃花，能否找到属于她的幸福真谛？","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/dbae579b-4030-4258-8455-fbd5c175c32c.jpg","化学工业出版社",10,10,6,1); -- id:8
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("怦然心动（精装纪念版）","文德琳·范·德拉安南","978-7-55964-454-1","一个独立、可爱又真挚的女生；
一个如彩虹般绚烂却不懂得爱的男生；
一篮鸡蛋、一棵无花果树和眼神交汇处闪亮的光芒；
关于初恋的那些小事，金色的阳光和清新美妙的少年时代。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/282ebb8b-caf9-4d1a-bd73-720a89f912a5.jpg","北京联合出版公司",10,10,3,1); -- id:9
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("罗小黑战记.1","MTJJ","978-7-55025-599-9","雨夜，一只流落街头的小黑猫，被少女罗小白带回家，起名罗小黑。罗小黑不是一只普通的猫咪，它极通人性，会蹲马桶，不吃猫粮，长长的尾巴甚至能分裂成多个名为“黑咻”的生物体。另一方面，名为“谛听”的神秘人物，发动手下三匹长着翅膀的狼，搜寻着罗小黑的下落。不久，罗小白带着小黑到乡下探望堂哥阿根和爷爷，由此发生了种种离奇玄幻事件。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/93c8a234-68a4-4ab9-b731-825a1354d350.jpg","北京联合出版公司",10,10,5,1); -- id:10
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("蓝溪镇.1","木头","978-7-55944-756-2","《蓝溪镇》，即《罗小黑战记》君清篇，讲述战争年代的老君、清凝和玄离的故事。
每逢乱世，老君便会四处游历，随缘带走无家可归之人，生活在他庇护之下。战乱过后，他们可以自由离开，也可选择留下。那处安身之所名为……蓝溪镇。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/4052dc3a-f6f9-4b32-8d8d-ceb7706478a0.jpg","江苏凤凰文艺出版社",10,10,5,1); -- id:11
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("你好，旧时光","八月长安","978-7-57260-715-8","青春究竟是什么呢？或许这本书能给你答案。
《你好，旧时光》一部关于岁月的童话，这里有回不去的小时候的伤感，也有陪你到青春最后的感动。愿你能够回想起你的成长故事，更愿你能找到属于自己的旧时光。
余周周的故事，也是你的故事。
给时间一点时间，因为你的青春，必将万事胜意。","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/e7fd5abf-0f5a-4be6-b5c0-773cf2d8716e.jpg","湖南文艺出版社",10,10,1,1); -- id:12
INSERT INTO book (title,author,isbn,book_content,book_cover_img,publisher,available_copies,total_copies,category_id,create_user) VALUES
("时光小旅馆","杰米·福特","978-7-53217-248-1","美国西雅图，唐人街与日本城交界处，有一座关闭三十六年之久的古旧建筑，狭窄的双扇门上写着“巴拿马旅馆”。四十多年前，这座旅馆曾见证了亨利一生好的和坏的时光。
四十多年后的今天，旅馆重新开业，人们意外发现地下室里藏有三十七个日裔家庭的行李。偶然经过旅馆的老亨利发现，行李中竟然有他熟悉的旧物﹣﹣一把绘有锦鲤的日式纸伞。尘封多时的记忆瞬间被唤醒：碎裂的老唱片、飘落的樱花、残酷的集中营，还有一个忽然离去的女孩。这么多年，他从未真正忘怀那个女孩。
四十四年了，她在哪里？她是否也在等着他？
“我会等你，等到这一切结束。”
“如果需要很多年呢？”
“我也会等。”","https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/ceb0e18b-c0bb-4276-964b-f773e9e0690a.jpg","上海文艺出版社",10,10,3,1); -- id:13
```

### 三、UI设计

> UI设计风格参考了pixso上的资源社区，[点我跳转到书店UI设计](https://pixso.cn/community/file/elOaOHzpSoaYRXpA-a1Jvg)

#### 3.1 登录和注册页面

![登录注册](https://github.com/xiaolan1001/BookBorrowingResource/blob/main/UI/login.png)

#### 3.2 文章详情界面
![文章详情](https://github.com/xiaolan1001/BookBorrowingResource/blob/main/UI/article.png)

#### 3.3 个人中心
![个人中心](https://github.com/xiaolan1001/BookBorrowingResource/blob/main/UI/profile.png)

#### 3.4 主页
![主页](https://github.com/xiaolan1001/BookBorrowingResource/blob/main/UI/home.png)

#### 3.5 借阅
![借阅](https://github.com/xiaolan1001/BookBorrowingResource/blob/main/UI/borrow.png)

#### 3.6 图书详情
![图书详情](https://github.com/xiaolan1001/BookBorrowingResource/blob/main/UI/detail.png)

#### 3.7 搜索
![搜索](https://github.com/xiaolan1001/BookBorrowingResource/blob/main/UI/search.png)