package com.nobody.selflearing;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.math.Vector2;

public class MainGame extends ApplicationAdapter  {
	private Drawer drawer;
	private HexMap map;
    
    @Override
    public void create() {        
    	drawer = new Drawer();
    	map = new HexMap(new Vector2(300,250),20,10);
    }

    @Override
    public void dispose() {
    	drawer.Dispose();
    }

    @Override
    public void render() {        
        Gdx.gl.glClearColor(1, 1, 1, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
        drawer.DrawManyConectedArrays(map.getPointsToRender(), 1, Color.BLACK);       
        drawer.DrawFont(Gdx.graphics.getFramesPerSecond()+":fps", new Vector2(10,14)); 
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
