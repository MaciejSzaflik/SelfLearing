package com.nobody.selflearing;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Input;
import com.badlogic.gdx.InputProcessor;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.math.Vector3;
import com.badlogic.gdx.utils.viewport.ExtendViewport;

public class MainGame extends ApplicationAdapter  {
	
	public final static float SCALE = 32f;
    public final static float INV_SCALE = 1.f/SCALE;
    public final static float VP_WIDTH = 1280 * INV_SCALE;
    public final static float VP_HEIGHT = 720 * INV_SCALE;
    public final static float CAMERA_WIDTH = 1280;
    public final static float CAMERA_HEIGHT = 720;

    private String debugString = "";
    private Coordinates currentMouseCoor = new Coordinates(0,0);
    private OrthographicCamera camera;
    public OrthographicCamera getCamera()
	{
		return camera;
	}
    private ExtendViewport viewport;
    public ExtendViewport getViewport()
	{
		return viewport;
	}
    private static MainGame instance;
	public static MainGame getInstance()
	{
		return instance;
	}
    
	private Drawer drawer;
	public Drawer getDrawer()
	{
		return drawer;
	}
	private HexMap map;
	private InputCatcher inputCatcher;
    
    @Override
    public void create() {   
    	instance = this;
    	inputCatcher = new InputCatcher();
    	camera = new OrthographicCamera(1280,720);
 
        viewport = new ExtendViewport(VP_WIDTH, VP_HEIGHT, camera);
        Gdx.input.setInputProcessor(inputCatcher);	
     
        drawer = new Drawer();
    	map = new HexMap(new Vector2(0,0),40,10);
    	
    	inputCatcher.AddInputListener((position) ->{
    		currentMouseCoor = map.positionToHex(position);
    		debugString = currentMouseCoor.toString(); 
    	});
    }

    @Override
    public void dispose() {
    	drawer.Dispose();
    }

    @Override
    public void render() {        
        Gdx.gl.glClearColor(1, 1, 1, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
        camera.update();
        drawer.SetProjectionMatrix(camera.combined);
        drawer.DrawManyConectedArrays(map.getPointsToRender(), 1, Color.BLACK);       
        drawer.DrawFont(Gdx.graphics.getFramesPerSecond()+":fps", procentToRealCamera(0.01f,0.08f)); 
        
        drawer.DrawHex(map.getHexCenterByAxialCor(currentMouseCoor),40,HexTopping.Pointy, Color.RED);
        
        drawer.DrawFont(debugString, procentToRealCamera(0.01f,0.04f)); 
    }
    	
    public Vector2 procentToRealCamera(float x, float y)
    {
    	return new Vector2(CAMERA_WIDTH*x - CAMERA_WIDTH*0.5f,CAMERA_HEIGHT*y - CAMERA_HEIGHT*0.5f);
    }

    @Override
    public void resize(int width, int height) {
    }

    @Override
    public void pause() {
    }

    @Override
    public void resume() {
    }
    
   
}
