import * as THREE from '../build/three.module.js';
import { OrbitControls } from './jsm/controls/OrbitControls.js';
import { GLTFLoader } from './jsm/loaders/GLTFLoader.js';
import { DRACOLoader } from './jsm/loaders/DRACOLoader.js'

let camera, scene, renderer, groundFX;

init();
render();


export function init() {

    const container = document.createElement( 'div' );
    document.body.appendChild( container );

    //camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 1000 );
    //camera.position.set( - 15, -20.5, 35.7 );

    camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 2000 );
				camera.position.set( 100, 200, 300 );

    scene = new THREE.Scene();
    scene.fog = new THREE.FogExp2( 0xa0a0a0, .005 );
    scene.background = new THREE.Color( 0xa0a0a0 );
    //scene.background = new THREE.Color( 0X999999 );

    const ambientLight = new THREE.AmbientLight( 0xcccccc, 0.55 ); // soft white light
    scene.add( ambientLight );
   
    const mesh = new THREE.Mesh( new THREE.PlaneGeometry( 1000, 1000 ));
    mesh.rotation.x = - Math.PI / 2;
    mesh.receiveShadow = true;
    mesh.material = new THREE.MeshStandardMaterial( { color: 0x999999 } )

    // const grid = new THREE.GridHelper( 2000, 20, 0x000000, 0x000000 );
    // grid.material.opacity = 0.2;
    // grid.material.transparent = true;
    // scene.add( grid );

    // const planeGeometry = new THREE.PlaneGeometry( 20, 20, 32, 32 );
    // const planeMaterial = new THREE.MeshStandardMaterial( { color: 0x999999 } )
    // const plane = new THREE.Mesh( planeGeometry, planeMaterial );
    // plane.receiveShadow = true;
    // scene.add( plane );
    scene.add( mesh );
    //scene.background = mesh;
    // Add some reflection to it
    // var planeGeometry = new THREE.PlaneBufferGeometry(1, 1);


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

    // const dirLight2 = new THREE.DirectionalLight( 0xffffff );
    // dirLight2.position.set( -15, 10, 2 );

    // scene.add( dirLight2 );


    // Shadow light helper... I hope we don't need this again
    //  const helper = new THREE.DirectionalLightHelper( dirLight, 5, "#FFFF00" );
    //  scene.add( helper );

    const loader = new GLTFLoader() ;
    const dracoLoader = new DRACOLoader();
    dracoLoader.setDecoderPath( '/src/draco/' );
    loader.setDRACOLoader( dracoLoader );
    loader.load( './models/bodies/brown.gltf', function ( gltf ) {
        gltf.scene.traverse( function ( child ) {

            if ( child.isMesh ) {
                child.castShadow = true; 
            }

        } );
        gltf.scene.position.y += 1.3

        scene.add( gltf.scene );
        render();
    } );

    loader.load( './models/wings/gray.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += 1.3

    	scene.add( gltf.scene );
    } );

    loader.load( './models/horns/blue.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += 1.3

    	scene.add( gltf.scene );
    } );

    loader.load( './models/eyes/blue.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += 1.3

    	scene.add( gltf.scene );
    	render();

    } );

    loader.load( './models/necklaces/medallion.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += 1.3

    	scene.add( gltf.scene );
    	render();

    } );

    loader.load( './models/eyebrows/brown.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += 1.3

    	scene.add( gltf.scene );
    	render();

    } );

    renderer = new THREE.WebGLRenderer( { antialias: true } );
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( window.innerWidth, window.innerHeight );
    //renderer.setSize( window.innerWidth -150, window.innerHeight -150 );
    //renderer.setSize( 450, 450 );
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1;
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.shadowMap.enabled = true;
    //renderer.shadowmap.type = THREE.PCFSoftwareShadowMap;

    render();

    container.appendChild( renderer.domElement );

    const controls = new OrbitControls( camera, renderer.domElement );
    controls.addEventListener( 'change', render ); // use if there is no animation loop
    controls.minDistance = 25;
    controls.maxDistance = 75;
    controls.target.set( 0, 9.4, - 0.2 );
    controls.maxPolarAngle = 1.55;
    //controls.autoRotate = true;
    controls.update();

    window.addEventListener( 'resize', onWindowResize );

    //render();

} 

export function onWindowResize() {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );

    render();

}

//

export function render() {
    
    renderer.render( scene, camera );

}