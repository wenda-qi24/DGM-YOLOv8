#!/bin/bash


seed=(11 21 31 41 51 61 71 81 91 101)
name=(v8)
version=(dgm-final)




for i in "${!seed[@]}"; do
    run_id=${seed[$i]}
  

    echo "=====  run?${run_id} ====="

    sbatch --job-name=${version}_${run_id} \
    --partition=gpu4090 \
    --gres=gpu:1 \
    --time=01:00:00 \
    --output=/path/to/logs/yolo_output/${name}${version}-${run_id}_%j.txt \
    << EOF
#!/bin/bash
source /etc/profile
module load python/3.11.11 cuda/11.8.0

cd /path/to/your/project/directory

source /path/to/your/project/ultralytics/env/bin/activate

export YOLO_CONFIG_DIR=/path/to/your/project/ultralytics/ultralytics/cfg

yolo obb val \\
    model=/path/to/your/project/ultralytics/runs/obb/train-${name}${version}-${run_id}/weights/best.pt \\
    data=/path/to/your/project/datasets/data.yaml \\
    split=test \\
    seed=20 \\
    device=0
EOF
done

echo ""