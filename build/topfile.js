import "../../../src/css/main.css";
import * as THREE from '../../three.module.js';
import { OrbitControls } from '../../../src/jsm/controls/OrbitControls.js';
import { GLTFLoader } from '../../../src/jsm/loaders/GLTFLoader.js';
import { DRACOLoader } from './jsm/loaders/DRACOLoader.js'
import { FlakesTexture } from '../../../src/jsm/textures/FlakesTexture.js';

let camera, scene, renderer, groundFX;

init();
render();

export function init() {
    //const gltfPath = './models/3dpigpreview.gltf';
    const container = document.createElement( 'div' );
    document.body.appendChild( container );

    camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 1000 );
    camera.position.set( - 15, -20.5, 35.7 );

    scene = new THREE.Scene();

    scene.background = new THREE.Color( 0X999999 );

    const ambientLight = new THREE.AmbientLight( 0xcccccc, 0.4 ); // soft white light
    scene.add( ambientLight );

    // Ground
    // Lets create a gold flake ground
    let texture = new THREE.CanvasTexture(new FlakesTexture());
    texture.wrapS = THREE.RepeatWrapping;
    texture.wrapT = THREE.RepeatWrapping;
    texture.repeat.x = 100;
    texture.repeat.y = 100;

    var groundMaterial = new THREE.MeshStandardMaterial( { 
        color: 0XF5F5F5, 
        metalness: .9, 
        roughness: 0.1, 
        //clearcoat: 1.0, 
        normalMap: texture, 
        normalScale: new THREE.Vector2(.15,.15) 
    } );
    
    const mesh = new THREE.Mesh( new THREE.PlaneGeometry( 1000, 1000 ), groundMaterial);
    mesh.rotation.x = - Math.PI / 2;
    mesh.receiveShadow = true;
    scene.add( mesh );

    // Shadow casting light
    const dirLight = new THREE.DirectionalLight( 0xffffff );
    dirLight.position.set( 3, 15, 10 );
    dirLight.castShadow = true;
    dirLight.shadow.camera.top = 30;
    dirLight.shadow.camera.bottom = - 30;
    dirLight.shadow.camera.left = - 30;
    dirLight.shadow.camera.right = 30;
    dirLight.shadow.camera.near = 0.1;
    dirLight.shadow.camera.far = 2540;
    dirLight.shadow.mapSize.width = 1540
    dirLight.shadow.mapSize.height = 1540

    scene.add( dirLight );

    // Shadow light helper... I hope we don't need this again
    // const helper = new THREE.DirectionalLightHelper( dirLight, 5, "#FFFF00" );
    // scene.add( helper );

    const loader = new GLTFLoader() ;
    const dracoLoader = new DRACOLoader();
    dracoLoader.setDecoderPath( '/src/draco/' );
    loader.setDRACOLoader( dracoLoader );