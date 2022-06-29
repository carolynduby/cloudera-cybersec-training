JAR_DEST_DIR=/home/training/jars/
JAR_SRC_DIR=/home/training/Desktop/training_materials/
if [[ -d "$JAR_DEST_DIR" ]]; then
    echo "Jars $JAR_DEST_DIR exists."
else
    echo "Creating jar directory  $JAR_DEST_DIR"
    mkdir -p $JAR_DEST_DIR
    mv $JAR_SRC_DIR/*.jar $JAR_DEST_DIR
fi
