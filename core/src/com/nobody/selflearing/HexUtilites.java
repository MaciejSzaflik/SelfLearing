package com.nobody.selflearing;

import com.badlogic.gdx.math.Vector2;

public class HexUtilites {
	
	public static Vector2[] getHexPoints(Vector2 center,float radius,HexTopping topping)
	{
		if(topping == HexTopping.Pointy)
			return getPointyToppedHexPoints(center,radius);
		else
			return getFlatToppedHexPoints(center,radius);
	}
	
	private static Vector2[] getPointyToppedHexPoints(Vector2 center,float radius)
	{	
		return new Vector2[]{
				center.cpy().mulAdd(new Vector2(-0.5f,0.25f), radius),	
				center.cpy().mulAdd(new Vector2(0,0.5f), radius),
				center.cpy().mulAdd(new Vector2(0.5f,0.25f), radius),
				center.cpy().mulAdd(new Vector2(0.5f,-0.25f), radius),
				center.cpy().mulAdd(new Vector2(0,-0.5f), radius),
				center.cpy().mulAdd(new Vector2(-0.5f,-0.25f), radius)
		};
	}
	
	private static Vector2[] getFlatToppedHexPoints(Vector2 center,float radius)
	{
		return new Vector2[]{
				center.cpy().mulAdd(new Vector2(-0.5f,0), radius),	
				center.cpy().mulAdd(new Vector2(-0.25f,0.5f), radius),
				center.cpy().mulAdd(new Vector2(0.25f,0.5f), radius),
				center.cpy().mulAdd(new Vector2(0.5f,0), radius),
				center.cpy().mulAdd(new Vector2(0.25f,-0.5f), radius),
				center.cpy().mulAdd(new Vector2(-0.25f,-0.5f), radius)
		};
	}
}
