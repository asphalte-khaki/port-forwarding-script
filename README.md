# Ultimate IP Forwarder Script v1.1

![License](https://img.shields.io/badge/license-MIT-green)
![Shell Script](https://img.shields.io/badge/language-Bash-yellow)

---

## توضیحات کلی

Ultimate IP Forwarder یک اسکریپت Bash حرفه‌ای برای **فورواردینگ چندپروتکلی** (TCP, UDP, TCP over UDP) روی سیستم‌عامل‌های اوبونتو 20.04 و بالاتر است.  
این اسکریپت از IPv4، IPv6 و دامنه پشتیبانی کرده و مدیریت آن از طریق منوی تعاملی کاملاً ساده انجام می‌شود.

---

## ویژگی‌ها

- پشتیبانی از TCP، UDP و TCP over UDP  
- فورواردینگ چند پورتی همزمان با استفاده از systemd  
- پشتیبانی کامل IPv4، IPv6 و دامنه‌ها  
- بهینه‌سازی تنظیمات سیستم برای فورواردینگ  
- منوی کاربری تعاملی و آسان  
- فعال‌سازی خودکار قوانین بعد از بوت سیستم  
- حذف یا غیرفعال کردن قوانین به راحتی  
- بدون نیاز به تغییر کد و نصب سریع

---

## پیش‌نیازها

- Ubuntu 20.04 یا جدیدتر  
- دسترسی root یا sudo  
- اتصال اینترنت برای نصب وابستگی‌ها

---

## نصب سریع

برای نصب و اجرای سریع اسکریپت کافی است در ترمینال سرور خود دستور زیر را اجرا کنید:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/asphalte-khaki/port-forwarding-script/main/ultimate_ip_forwarder.sh)
