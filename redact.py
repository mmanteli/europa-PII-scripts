import re
import sys
import json
import string
from pii_manager import PiiEnum
from pii_manager.api import PiiManager
from pii_manager.lang import COUNTRY_ANY, LANG_ANY
# Define language, country(ies) and PII tasks
lang = sys.argv[1]
country=COUNTRY_ANY
tasklist = (PiiEnum.IP_ADDRESS, PiiEnum.EMAIL_ADDRESS, PiiEnum.PHONE_NUMBER)


# Here some reroutes between our filenames and PiiManager langauges
if lang=="is":   # the tool has problems with python-vocab words. With India, this was solved with "in_" but "is_" refused to work
    lang="ic"
elif lang=="ca":
    lang="es"
elif lang=="cy":
    lang="en"
    country="uk"  # this is simply to make running faster, "en" has a lot of rules and we can stick to UK only
elif lang=="ga": 
    lang="es"

proc = PiiManager(lang, country, tasks=tasklist, mode="convert")

for line in sys.stdin:
    j = json.loads(line)
    j["raw_content"]=proc(j["raw_content"])   # "text" in culturax and hplt, "raw_content" in redpajama
    print(json.dumps(j))
