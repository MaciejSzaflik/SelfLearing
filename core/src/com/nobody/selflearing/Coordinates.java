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
	
	@Override public String toString()
	{
		return String.format("%1$d:%2$d", q, r);
	}
	
}
