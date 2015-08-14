#!/bin/bash
#author by ray at 20141130


###HTTPD RELEVANT

T_FILES=tengine-2.0.3.tar.gz
T_FILES_DIR=tengine-2.0.3
T_URL=http://tengine.taobao.org/download/
T_PREFIX=/usr/local/ProgramData/Tengine-2.0.3

###MYSQLD RELEVANT

M_FILES=mysql-5.5.41.tar.gz
M_FILES_DIR=mysql-5.5.41
M_URL=http://mirrors.sohu.com/mysql/MySQL-5.5
M_PREFIX=/usr/local/ProgramData/Mysql_5.5.41


###PHP RELEVANT

P_FILES=php-5.6.3.tar.gz
P_FILES_DIR=php-5.6.3
P_URL=http://mirrors.sohu.com/php
P_PREFIX=/usr/local/ProgramData/PHP_5.6.3



#if [ -z "$1" ];then
#	echo -e "\033[32mPlease Select Install Menu follow:\033[0m"
#	echo -e "\033[3m1)编译安装Tengine服务器\033[1m"
#	echo "2)编译安装MySQL服务器"
#	echo "3)编译安装PHP服务器"
#	echo "4)配置index.php并启动LAMP服务"
#	echo -e "\033[31mUsage:{ /bin/bash $0 1|2|3|4|help}\033[0m"
#	exit
#fi

####auto install httpd server
function tengine() 
{

	yum -y install libxslt* libxml2* pcre* gd* zlib* lua* GeoIP* openssl* 
        yum -y groupinstall "Development Tools" "Development Libraries" 
	ln -sf /usr/include/openssl/*.h /usr/include/
	ln -sf /usr/lib/openssl/engines/*.so /usr/lib/
	ln -sf /usr/include/gd.* /usr/lib/
	/usr/sbin/useradd -s /sbin/nologin nginx
	wget https://raw.githubusercontent.com/xiarui0774/Soft/master/ngx_cache_purge-2.3.tar.gz && tar zxf ngx_cache_purge-2.3.tar.gz 
	wget -c $T_URL/$T_FILES && tar -zxf $T_FILES && cd $T_FILES_DIR && ./configure --prefix=$T_PREFIX --user=nginx --group=nginx --enable-mods-shared=all --enable-mods-static=all --with-rtsig_module --with-select_module --with-poll_module --with-file-aio --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module  --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_sub_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_flv_module --with-http_dav_module --with-pcre --with-http_ssl_module --with-http_concat_module --add-module=../ngx_cache_purge-2.3
	if [ $? -eq 0 ];then
		make && make install 
		ln -s $T_PREFIX /usr/local/nginx
		echo -e "\033[32mTHE Tengine Server has been installed successful!\033[0m"
	else
		echo -e "\033[32mTHE Tengine server Installation is failed,please exit and check!\033[0m"
		exit
	fi
}


######auto install mysql server
function mysql()
{
        /usr/sbin/useradd -s /sbin/nolgin mysql	
	wget -c $M_URL/$M_FILES && tar -zxf $M_FILES && cd $M_FILES_DIR && yum install cmake ncurses* -y;cmake . -DCMAKE_INSTALL_PREFIX=$M_PREFIX -DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock -DMYSQL_DATADIR=/usr/local/mysql/data -DSYSCONFDIR=/usr/local/mysql/etc -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306 -DWITH_XTRADB_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_EXTRA_CHARSET=1 -DENABLED_LOCAL_INFILE=1 -DWITH_EXTRA_CHARSET=1 -DDEFAULT_CHARSET=UTF8 -DDEFAULT_COLLATION=utf8_general_ci -DEXTRA_CHARSETS=ll -DWITH_BIG_TABLES=1 -DWITH_DEBUG=0
	
	if [ $? -eq 0 ];then
		make && make install 
		ln -s /usr/local/ProgramData/Mysql_5.5.41 /usr/local/mysql
		mkdir /usr/local/mysql/etc
		/bin/cp support-files/my-small.cnf /usr/local/mysql/etc/my.cnf
		/bin/cp support-files/mysql.server /etc/rc.d/init.d/mysqld
		/sbin/chkconfig --add mysqld && chkconfig mysqld on
		chown -R mysql.mysql /usr/local/mysql
		echo -e "\033[32mTHE Mysqld Server has been installed successfully!\033[0m"
	else
		echo -e "\033[32mTHE Mysql Server Installation is failed,please exit and check!\033[0m"
		exit
	fi
}


####auto install php server
function php()
{
	yum install libxml*  libjpeg* libpng* zlib* libXmp* freetype* gd* gettext* mhash* libmcrypt*  curl* -y 

	wget -c $P_URL/$P_FILES && tar zxf $P_FILES && cd $P_FILES_DIR && yum install libxml2* -y;./configure --prefix=$P_PREFIX --enable-embed=static --enable-fpm --with-config-file-path=/usr/local/php/etc --with-libxml-dir=/usr/lib --with-openssl --with-zlib --enable-bcmath --with-curl=/usr/lib --enable-exif --with-pcre-dir=/usr/lib --enable-ftp --with-gd --with-jpeg-dir=/usr/lib --with-png-dir=/usr/lib --with-zlib-dir=usr/lib --with-xpm-dir=/usr/lib --with-freetype-dir=/usr/lib --enable-gd-jis-conv --enable-gd-native-ttf --with-gettext=usr/lib --with-mhash=/usr/lib --enable-mbstring=all --with-mcrypt=/usr/lib --with-mysql-/usr/local/mysql --with-mysql-sock=/usr/local/mysql/mysql.sock --with-mysqli=/usr/local/mysql/bin/mysql_config --enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-zip
	if [ $? -eq 0 ];then
		make && make install
		ln -s /usr/local/ProgramData/PHP_5.6.3 /usr/local/php
		/bin/cp ./php.ini-production /usr/local/php/etc/
		echo -e "\033[32m The PHP server has been installed successfully!\033[0m"
	else
		echo -e "\033[32mTHE PHP Server Installation is failed,please exit and check!\033[0m"
		exit
		
	fi
}


echo -e "\033[32m---------------------------\033[1m"
PS3="Please Select Menu Follow:"
select i in "tengine_install" "mysql_install" "php_install" "Exit_Install"
do
	case $i in 
		tengine_install)
		tengine $1
		;;
		mysql_install)
		mysql $1
		;;
		php_install)
		php $1
		;;
		Exit_Install)
		exit
		;;
	esac	
done	
