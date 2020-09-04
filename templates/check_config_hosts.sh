#!/bin/bash

tendb_shard_num={{tendbcluster_shard_num}}
tendb_shard_num=0
tendb_shard_names=""
tendb_shard_ids=""

## collect
{% for g in groups %}
{% if g.startswith("SPT") %}
shard_name={{g}}
tendb_shard_names+="${shard_name:3}"
tendb_shard_ids+="${shard_name} "
let tendb_shard_num+=1

## shard={{g}}
shard_master=""
shard_master_master=""
shard_instances=""
{% for h in groups[g] %}
instance={{h}}
shard_instances+="${instance} "
{% if hostvars[h]['role'] == "master" %}
shard_master="${instance} "
shard_master_master={{hostvars[h]['master']}}
{% if hostvars[h].master is defined %}
shard_master_master="{{hostvars[h]['master']}} "
{% else %}
shard_master_master="$shard_master"
{% endif %}
{% endif %}
{% endfor %}
if [ "$shard_master" = "" ];then
  echo "[shard=$shard_name] no master found"
  exit 1
elif [[ $shard_instances != *"$shard_master"* ]];then
  echo "[shard=$shard_name] master=$shard_master not in this shard"
  exit 1
elif [ $shard_master_master != $shard_master ];
  echo "[shard=$shard_name] wrong master for instance=$shard_master"
  exit 1
fi

{% endif %}
{% endfor %}

# check
if [ $tendb_shard_num -ne {{tendbcluster_shard_num}} ];then
  echo "tendb shard number not matched"
  exit 1
fi

{% for h in groups["tendb"] %}

{% endfor %}
