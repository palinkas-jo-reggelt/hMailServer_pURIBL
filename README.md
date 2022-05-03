# hMailServer_pURIBL
 Personal URIBL for hMailServer

# Description
 Scans spam (messages with spam score above delete threshold) for URIs and inserts them into database.

 Reviews incoming messages for matching URIs and scores them as spam if matching URI found.
 
# Instructions
 Create database

```
CREATE TABLE IF NOT EXISTS hm_puribluri (
	id int(11) NOT NULL AUTO_INCREMENT,
	uri text NOT NULL,
	timestamp datetime NOT NULL,
	adds mediumint(9) NOT NULL,
	hits mediumint(9) NOT NULL,
	active tinyint(1) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY uri (uri) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
COMMIT;

CREATE TABLE IF NOT EXISTS hm_puribldom (
	id int(11) NOT NULL AUTO_INCREMENT,
	domain text NOT NULL,
	timestamp datetime NOT NULL,
	adds mediumint(9) NOT NULL,
	hits mediumint(9) NOT NULL,
	shortcircuit tinyint(1) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY uri (domain) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
COMMIT;
```

 Copy the contents of EventHandlers.vbs into your EventHandlers.vbs
 
 Copy public_suffix_list.vbs into hMailServer Events folder. Alternatively, make your own using PublicSuffixLoad.ps1. public_suffix_list.vbs should be updated monthly as the list changes over time.
 
 Copy contents of www folder into web server for management tools

# PHP Management
 There are two categories: Domains and URIs.
 
 URIs are full URIs. They can be set to inactive so they won't be used for matching.
 
 Domains are the highest full domain not including subdomains. They are scraped from the URIs collected. They can be set to short circuit, which means if a match is made with the domain, it will score and stop looking for individual URIs.
 