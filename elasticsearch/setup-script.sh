#!/bin/bash
#Adding indicies to Elastic
curl -XPUT "http://localhost:9200/zap" -H 'Content-Type: application/json' -d'{"mappings": {"properties": {"datetime": {"type": "date"},"sourceid": {"type": "long"},"other": {"type": "text"},"method": {"type": "keyword"},"evidence": {"type": "text"},"pluginId": {"type": "long"},"cweid": {"type": "long"},"confidence": {"type": "keyword"},"wascid": {"type": "long"},"description": {"type": "text"},"messageId": {"type": "long"},"url": {"type": "text","fielddata": true},"reference": {"type": "text"},"solution": {"type": "text"},"alert": {"type": "text"},"param": {"type": "keyword"},"attack": {"type": "text"},"name": {"type": "keyword"},"risk": {"type": "keyword"}}}}'
curl -XPUT "http://localhost:9200/_ingest/pipeline/preprocess" -H 'Content-Type: application/json' -d'{"description": "add timestamp field to the document, requires a datetime field date mapping","processors": [{"remove": {"field": ["id","sourceid","method","pluginId","cweid","wascid","messageId","param"]},"set": {"field": "datetime","value": "{{_ingest.timestamp}}"}}]}'