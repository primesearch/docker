#!/bin/bash

# Start MPrime
# Run: ./MPrime.sh

set -e

# Set these variables

prime_ID=${PRIME_ID:-Default}
computer_name=${COMPUTER_NAME:-Default}
type_of_work=${TYPE_OF_WORK:-150}
prp_proof_power=${PRP_PROOF_POWER:-Default}
prp_proof_power_mult=${PRP_PROOF_POWER_MULT:-Default}
# 1 = true, 0 = false
proof_certification_work=${PROOF_CERTIFICATION_WORK:-1}
debug=${DEBUG:-0}

run() {
	# Run MPrime
	echo -e '\nStarting MPrime\n'
	./mprime -d | tee -ia mprime.out
}

debug_exit() {
	# Output of MPrime
	if [[ -f mprime.out ]]; then
		echo -e "\nMPrime output:\n"
		tail -n 100 mprime.out # view MPrime progress
		./mprime -s
		echo
	else
		echo -e "No output file found for debug option.\n"
	fi
}

install() {
	# Install/Configure MPrime
	echo -e "\nSetting up MPrime\n"
	sed -i '/^expect {/a \\t"Get occasional proof certification work (*):" { sleep 1; send -- "'$proof_certification_work'\\r"; exp_continue }' mprime.exp
	sed -i '/^expect {/a \\t"stage 2 memory in GiB (*):" { sleep 1; send -- "'"$(echo "$TOTAL_PHYSICAL_MEM" | awk '{ printf "%g", ($1 * 0.8) / 1024 / 1024 }')"'\\r"; exp_continue }' mprime.exp
	expect mprime.exp -- "$prime_ID" "$computer_name" "$type_of_work" # Run script
	file=prime.txt
	echo 'FixedHardwareUID=1' >temp.txt
	echo 'KeepPminus1SaveFiles=0' >>temp.txt
	if [[ $prp_proof_power != 'Default' ]]; then
		echo "ProofPower=$prp_proof_power" >>temp.txt
	fi
	if [[ $prp_proof_power_mult != 'Default' ]]; then
		echo "ProofPowerMult=$prp_proof_power_mult" >>temp.txt
	fi
	cat $file >>temp.txt
	mv temp.txt $file
	run
}

wget -qO - https://raw.github.com/tdulcet/Linux-System-Information/master/info.sh | bash -s # Check System Info
echo

# use/cleanup input from user
if [[ ${prime_ID,,} == 'default' ]]; then
	prime_ID='psu'
fi

if [[ ${computer_name,,} == 'default' ]]; then
	computer_name=''
fi
computer_name=${computer_name:-$HOSTNAME}

if ((proof_certification_work)); then
	proof_certification_work=y
else
	proof_certification_work=n
fi

TOTAL_PHYSICAL_MEM=$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)

if ((debug)); then
	debug_exit
	exit
fi

if [[ -f worktodo.txt ]]; then
	echo -e "$(date)\t$(sed -n 's/^model name[[:space:]]*: *//p' /proc/cpuinfo | uniq)  $(sed -n 's/^model[[:space:]]*: *//p' /proc/cpuinfo | uniq)" >>cpus.txt
	echo -e '\nPrevious CPU counts'
	cut -f 2 cpus.txt | sort | uniq -c | sort -nr
	run
else
	install
fi

echo 'Gracefully exiting...'
