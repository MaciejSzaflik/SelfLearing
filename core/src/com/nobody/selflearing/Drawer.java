package com.nobody.selflearing;

import java.util.List;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.math.Vector2;

public class Drawer {
	private ShapeRenderer shapeRenderer;
	private SpriteBatch batch;
	private BitmapFont font;
	
	public Drawer(){
		batch = new SpriteBatch();
		shapeRenderer = new ShapeRenderer();
		font = new BitmapFont();
		font.setColor(Color.BLACK);
	}
		
	public void DrawLine(Vector2 start, Vector2 end, int lineWidth, Color color)
    {
		InitLineRenderingWithWidthAndColor(lineWidth,color);
        shapeRenderer.line(start, end);
        FinishLineRendering();
    }
	private void InitLineRenderingWithWidthAndColor(int lineWidth,Color color)
	{
		Gdx.gl.glLineWidth(lineWidth);
        shapeRenderer.setProjectionMatrix(batch.getProjectionMatrix());
        shapeRenderer.begin(ShapeRenderer.ShapeType.Line);
        shapeRenderer.setColor(color);
	}
	private void FinishLineRendering()
	{
		shapeRenderer.end();
        Gdx.gl.glLineWidth(1);
	}
	
	public void DrawPointsArray(Vector2[] points, int lineWidth, Color color)
	{
		InitLineRenderingWithWidthAndColor(lineWidth,color);
		for(int i = 0;i<points.length-1;i++)
			shapeRenderer.line(points[i], points[i+1]);
		FinishLineRendering();
	}
	
	public void DrawConnectedPointsArray(Vector2[] points, int lineWidth, Color color)
	{
		InitLineRenderingWithWidthAndColor(lineWidth,color);
		MakeConectedLinesWithShapeRenderer(points);
		FinishLineRendering();
	}
	
	public void DrawManyConectedArrays(List<Vector2[]> listOfPoints, int lineWidth, Color color)
	{
		InitLineRenderingWithWidthAndColor(lineWidth,color);
		for(Vector2[] points : listOfPoints)
			MakeConectedLinesWithShapeRenderer(points);
			
		FinishLineRendering();
	}
	private void MakeConectedLinesWithShapeRenderer(Vector2[] points)
	{
		for(int i = 0;i<points.length;i++)
			shapeRenderer.line(points[i], points[(i+1)%points.length]);
	}
	
	
	public void DrawHex(Vector2 center,float radius, int lineWidth, Color color,HexTopping hexTop)
	{
        DrawConnectedPointsArray(HexUtilites.getHexPoints(center,radius,hexTop),lineWidth,color);
	}
	
	public void DrawFont(String textValue,Vector2 position)
	{
		batch.begin();
	    font.draw(batch, textValue, position.x, position.y);
	    batch.end();
	}
	
	public void Dispose()
	{
		batch.dispose();
		shapeRenderer.dispose();
		font.dispose();
	}

}
