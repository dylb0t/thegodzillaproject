import * as THREE from '../build/three.module.js';
import { OrbitControls } from './jsm/controls/OrbitControls.js';
import { GLTFLoader } from './jsm/loaders/GLTFLoader.js';
import { DRACOLoader } from './jsm/loaders/DRACOLoader.js'
import { FlakesTexture } from './jsm/textures/FlakesTexture.js';

let camera, scene, renderer, groundFX;

init();
render();
//animate();

// var manager = new THREE.LoadingManager();

// manager.onProgress = function ( url, itemsLoaded, itemsTotal ) {
//     progressElement.style.width = (itemsLoaded / itemsTotal * 100) + '%';
// };

export function init() {

    // const loadingManager = new THREE.LoadingManager( () => {
	
	// 	const loadingScreen = document.getElementById( 'loading-screen' );
	// 	loadingScreen.classList.add( 'fade-out' );
		
	// 	// optional: remove loader from DOM via event listener
	// 	loadingScreen.addEventListener( 'transitionend', loadingScreen.onTransitionEnd );
		
	// } );

    //const gltfPath = './models/3dpigpreview.gltf';
    //cost gltfPath = new gltfPath();
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
    //scene.background = mesh;
    // Add some reflection to it
    // var planeGeometry = new THREE.PlaneBufferGeometry(1, 1);

    // var mirrorOptions = {
    // 	clipBias:0.03,
    // 	textureWidth: window.innerWidth * window.devicePixelRatio,
    // 	textureHeight: window.innerHeight * window.DevicePixelRatio,
    // 	recursion: 1
    // }

    // var mirror = new Reflector(planeGeometry, mirrorOptions);
    // mirror.rotateX(-Math.PI /2);
    // scene.add(mirror);

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

    // const dirLight2 = new THREE.DirectionalLight( 0xffffff );
    // dirLight2.position.set( -15, 10, 2 );

    // scene.add( dirLight2 );


    // Shadow light helper... I hope we don't need this again
    // const helper = new THREE.DirectionalLightHelper( dirLight, 5, "#FFFF00" );
    // scene.add( helper );

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
        //This positions the model right at the ground
        //gltf.scene.position.y += 9.4
        //But the wings go below the ground so lets try to raise osme more
        gltf.scene.position.y += .2

        scene.add( gltf.scene );
        render();
    } );

    loader.load( './models/wings/gray.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += .2

    	scene.add( gltf.scene );
    	//render();

    } );

    loader.load( './models/horns/blue.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += .2

    	scene.add( gltf.scene );
    	//render();

    } );

    loader.load( './models/eyes/blue.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += .2

    	scene.add( gltf.scene );
    	render();

    } );

    loader.load( './models/necklaces/medallion.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += .2

    	scene.add( gltf.scene );
    	render();

    } );

    loader.load( './models/eyebrows/brown.gltf', function ( gltf ) {
    	gltf.scene.traverse( function ( child ) {

    		if ( child.isMesh ) {
    			child.castShadow = true; 
    		}
    	} );
    	gltf.scene.position.y += .2

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