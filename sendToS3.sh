bucket=net-monitor-logs
files_location=/home/joseph/NetMonitor/s3Files/
now_time=$(date +"%H%M%S")
contentType="application/x-compressed-tar"
dateValue=`date -R`
# your key goes here..
s3Key=AKIATLXESS3HSWEW45NQ
# your secrets goes here..
s3Secret=E7d4Lw6vOcIt9NhTg+4/MSIBoIVrUutxo/h40NNr

function pushToS3()
{
  files_path=$1
  for file in $files_path*
  do
    fname=$(basename $file)
    resource="/${bucket}/${now_date}/${fname}_${now_time}"
    stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
    signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
    curl -X PUT -T "${file}" \
     -H "Host: ${bucket}.s3.amazonaws.com" \
     -H "Date: ${dateValue}" \
     -H "Content-Type: ${contentType}" \
     -H "Authorization: AWS ${s3Key}:${signature}" \
      https://${bucket}.s3.amazonaws.com/${now_date}/${fname}_${now_time}
  done
}
pushToS3 $files_location