#!/bin/bash

# need : docker,jq,skopeo (docker is not neccessary )
# change: default_path, insecure_policy(default to 0)
# chmod+x this script , run it
# image format should be : b3log/siyuan:v2.9.0    
#  装好docker，jq，skopeo， dockers不是必须，jq和skopeo包管理器里下，没有就用预编译的，找我要
#  修改下载目录，和调整是否用兼容模式
#  给运行权限，执行，输入镜像名，最好带tag
#


echo 'you need Docker,Jq,Skopeo installed'
default_path="/volume1/homes/fanli/Drive/docker_images"
insecure_policy=1 #0 to disable
echo ' default path is ' $default_path
read -r -p "please type image name , eg: b3log/siyuan:v2.9.0   :" image
#image="b3log/siyuan:v2.9.0"
manifest=$(docker manifest inspect $image)

if [ "$manifest" == "" ];then
echo "!!!!! docker couldnt load manifest , using skopeo instead"
manifest=$(skopeo inspect docker://$image --raw)
fi

echo " -----------------------------"
echo " -----------------------------"
echo "$manifest" | jq -r '.manifests[] | select(.platform.architecture != "unknown") | .platform.architecture + " " + .platform.os + " " + (.platform.variant // "")' | while read -r line
do
  arr=($line)
  arch="${arr[0]}"
  os="${arr[1]}"
  variant="${arr[2]}"
  
  filename="$default_path/${image/\//_}_${arch}_${os}_${variant}.tar"
  filename=$(echo $filename|sed 's/:/\//g')
  directory=$(echo $filename | sed 's/\/[^/]*$//')
  echo  'mkdir -p ' $directory

  if [ "$variant" = "" ]; then
    skopeo_cmd="skopeo copy --override-os $os --override-arch $arch docker://docker.io/$image docker-archive:${filename}_$arch"
  else
    skopeo_cmd="skopeo copy --override-os $os --override-arch $arch --override-variant $variant docker://docker.io/$image docker-archive:${filename}_$arch"
  fi
  
  if [ ${insecure_policy} -eq 1 ];then
  skopeo_cmd=$(echo $skopeo_cmd|sed 's/copy/--insecure-policy copy/g')
  fi

  echo $skopeo_cmd
done

echo " -----------------------------"
echo " -----------------------------"
