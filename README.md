# dockerhub2local
keep your favorate images forever

ref:

- https://github.com/containers/skopeo
- https://github.com/lework/skopeo-binary/releases
- https://github.com/jqlang/jq/releases/tag/jq-1.7
- https://github.com/containers/skopeo/issues/181

steps:
how to save images
- read , download and run dockerhub2local.sh
- chmod +x dockerhub2local.sh; ./dockerhub2local.sh
- input image, eg :b3log/siyuan:v2.9.0
how to load images
- docker load < ***.tar
- docker tag <id> b3log/siyuan:v2.9.0offlined  # replace <id> to your images id 
