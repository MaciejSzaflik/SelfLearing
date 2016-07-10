package com.nobody.selflearing;

import com.badlogic.gdx.math.Vector2;

public class Hex {
	private Vector2 center;
	public Vector2 getCenter()
	{
		return center;
	}
	
	private Coordinates coor;
	
	public Hex(Vector2 center, Coordinates coor)
	{
		this.center = center;
		this.coor = coor;
	}
	
	public String getStringRep()
	{
		return String.format("%1$d:%2$d", coor.r, coor.c);
	}
	
}
