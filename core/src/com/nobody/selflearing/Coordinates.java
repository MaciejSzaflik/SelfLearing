package com.nobody.selflearing;

public class Coordinates {
	public int q;
	public int r;
	
	public int getX()
	{
		return q;
	}
	public int getY()
	{
		return -q - r;
	}
	public int getZ()
	{
		return r;
	}
	
	public Coordinates(int r, int c)
	{
		this.q = r;
		this.r = c;
	}
	
	public String toString()
	{
		return q+":"+r;
	}
	
}
