#!/bin/bash

seeds=(71 81 91 101)
name=(v8)
version=(dgm-final)


for seed in "${seeds[@]}"; do
    echo "====== seed=${seed} ======"
    sbatch --job-name=${version}-${seed} \
    --partition=gpu4090 \
    --gres=gpu:1 \
    --time=01:00:00 \
    --output=/path/to/logs/yolo-${name}${version}_${seed}_%j.txt \
    << EOF
#!/bin/bash
source /etc/profile
module load python/3.11.11 cuda/11.8.0

cd /path/to/your/project/directory

source /path/to/your/project/ultralytics/env/bin/activate

export YOLO_CONFIG_DIR=/path/to/your/project/ultralytics/ultralytics/cfg

yolo obb train \
    model=yolov8m-obb-dgm.yaml \
    data=/path/to/your/project/datasets/data.yaml \
    epochs=100 \
    imgsz=640 \
    seed=${seed} \
    pretrained=False \
    name=train-${name}${version}-${seed} \
    device=0
EOF
done
