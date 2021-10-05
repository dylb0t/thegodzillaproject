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
    controls.maxPolarAngle = 1.55
    controls.update();

    window.addEventListener( 'resize', onWindowResize );

    //render();

} 

function onWindowResize() {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );

    render();

}

//

function render() {

    renderer.render( scene, camera );

}