import socket

from .base import *

DEBUG = True
TEST_RUNNER = "django_rich.test.RichRunner"
INSTALLED_APPS += ["debug_toolbar", "django_browser_reload"]
MIDDLEWARE += [
    "debug_toolbar.middleware.DebugToolbarMiddleware",
    "django_browser_reload.middleware.BrowserReloadMiddleware",
]

# Find local IPs for debug toolbar
hostname, _, ips = socket.gethostbyname_ex(socket.gethostname())
INTERNAL_IPS = [ip[: ip.rfind(".")] + ".1" for ip in ips] + [
    "127.0.0.1",
    "10.0.2.2",
    "192.168.65.1",
]
