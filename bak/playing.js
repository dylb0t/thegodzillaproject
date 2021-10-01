const { Document, Scene, WebIO } = require('@gltf-transform/core');

doc = new Document("./ed1a190e834ff75114f578929670470a");

const mesh = doc.getRoot()
  .listMeshes()
  .forEach((mesh) => {
    console.log(mesh);
  });
//doc.foreach(mesh => console.log(mesh));