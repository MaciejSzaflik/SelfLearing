package com.nobody.selflearing;

import java.util.ArrayList;
import java.util.List;

import com.badlogic.gdx.Input;
import com.badlogic.gdx.InputProcessor;
import com.badlogic.gdx.math.Vector3;

public class InputCatcher implements InputProcessor{

	private List<OnMouseMove> onMouseMoveListeners; 
	
	public InputCatcher()
	{
		onMouseMoveListeners = new ArrayList<OnMouseMove>();
	}
	
	public void AddInputListener(OnMouseMove listener)
	{
		onMouseMoveListeners.add(listener);
	}
	
	private void notifyAllOnMouseMove(Vector3 currentPosition)
	{
		for(OnMouseMove listener : onMouseMoveListeners)
			listener.onMouseMove(currentPosition);
	}
	
	Vector3 tp = new Vector3();
    boolean dragging;
    @Override public boolean mouseMoved (int screenX, int screenY) {
        // we can also handle mouse movement without anything pressed
       MainGame.getInstance().getCamera().unproject(tp.set(screenX, screenY, 0));
       notifyAllOnMouseMove(tp);
       return false;
    }

    @Override public boolean touchDown (int screenX, int screenY, int pointer, int button) {
        // ignore if its not left mouse button or first touch pointer
        if (button != Input.Buttons.LEFT || pointer > 0) return false;
        MainGame.getInstance().getCamera().unproject(tp.set(screenX, screenY, 0));
        dragging = true;
        return true;
    }

    @Override public boolean touchDragged (int screenX, int screenY, int pointer) {
        if (!dragging) return false;
        MainGame.getInstance().getCamera().unproject(tp.set(screenX, screenY, 0));
        return true;
    }

    @Override public boolean touchUp (int screenX, int screenY, int pointer, int button) {
        if (button != Input.Buttons.LEFT || pointer > 0) return false;
        MainGame.getInstance().getCamera().unproject(tp.set(screenX, screenY, 0));
        dragging = false;
        return true;
    }

	@Override
	public boolean keyDown(int keycode) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean keyUp(int keycode) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean keyTyped(char character) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean scrolled(int amount) {
		// TODO Auto-generated method stub
		return false;
	}
}
