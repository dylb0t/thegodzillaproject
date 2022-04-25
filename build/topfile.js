import "../../../src/css/main.css";
import * as THREE from '../../three.module.js';
import { OrbitControls } from '../../../src/jsm/controls/OrbitControls.js';
import { GLTFLoader } from '../../../src/jsm/loaders/GLTFLoader.js';
import { DRACOLoader } from '../../../src/jsm/loaders/DRACOLoader.js'

let camera, scene, renderer, groundFX;

init();
render();

export function init() {
    const container = document.createElement( 'div' );
    document.body.appendChild( container );

    camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 2000 );
	camera.position.set( -20, 30, 35 );

    scene = new THREE.Scene();
    scene.fog = new THREE.FogExp2( 0xe397a6, .005 );
    scene.background = new THREE.Color( 0xe397a6 );

    const ambientLight = new THREE.AmbientLight( 0xcccccc, 0.55 ); // soft white light
    scene.add( ambientLight );

    // Ground
    
    const mesh = new THREE.Mesh( new THREE.PlaneGeometry( 1000, 1000 ));
    mesh.rotation.x = - Math.PI / 2;
    mesh.receiveShadow = true;
    mesh.material = new THREE.MeshStandardMaterial( { color: 0xe397a6 } )

    scene.add( mesh );

    // Shadow casting light
    const dirLight = new THREE.DirectionalLight( 0x999999, .55 );
    dirLight.position.set( 3, 25, 10 );
    dirLight.castShadow = true;
    dirLight.shadow.camera.top = 30;
    dirLight.shadow.camera.bottom = - 30;
    dirLight.shadow.camera.left = - 60;
    dirLight.shadow.camera.right = 60;
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
    dracoLoader.setDecoderPath( '../../draco/' );
    loader.setDRACOLoader( dracoLoader );