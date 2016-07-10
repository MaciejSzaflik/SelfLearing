package com.nobody.selflearing;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.math.Vector3;

public class Hex {
	private Vector2 center;
	public Vector2 getCenter()
	{
		return center;
	}
	
	public Vector3 getCenterAsVector3()
	{
		return new Vector3(center.x,center.y,0);
	}
	
	private Coordinates coor;
	
	public Hex(Vector2 center, Coordinates coor)
	{
		this.center = center;
		this.coor = coor;
	}
	
	public String getStringRep()
	{
		return String.format("%1$d:%2$d", coor.q, coor.r);
	}
	
}
