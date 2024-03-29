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
	domain varchar(128) NOT NULL,
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
	UNIQUE KEY domain (domain) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
COMMIT;
```

 Copy the contents of Events/EventHandlers.vbs into your EventHandlers.vbs.
 
 Copy Events/public_suffix_list.vbs into hMailServer Events folder. Alternatively, make your own using PublicSuffixLoad.ps1. public_suffix_list.vbs should be updated monthly as the list changes over time.
 
 Copy contents of main folder (PHP files + VERSION file) into web server for management tools. Rename config.php.dist to config.php and update the variables.

# PHP Management
 There are two categories: Domains and URIs.
 
 URIs are full URIs. They can be set to inactive so they won't be used for matching.
 
 Domains are the highest full domain not including subdomains. They are scraped from the URIs collected. They can be set to short circuit, which means if a match is made with the domain, it will score and stop looking for individual URIs. Deleting a domain will also delete all associated URIs.
 
 Clicking on URIs or domains, of course, will not launch your browser toward a potential virus. Clicking on a domain will search for matching URIs. Clicking on a URI will bring up its properties for editing.
 