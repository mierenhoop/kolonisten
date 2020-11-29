module rotationview;

import dagon.ui.freeview;
import dagon.core.event;
import dagon.graphics.entity;
import dagon.core.time;
import dagon.core.keycodes;
import dlib.math;

class RotationViewComponent : FreeviewComponent
{
    float zoomSpeed;

    this(EventManager ev, Entity en)
    {
        super(ev, en);
        zoomSpeed = 1.0;
    }

    override void update(Time time)
    {
        processEvents();

        if (active)
        {

            if (eventManager.mouseButtonPressed[MB_RIGHT])
            {
                float t = (eventManager.mouseX - prevMouseX);
                float p = (eventManager.mouseY - prevMouseY);
                pitchSmooth(p, 4.0f);
                turnSmooth(t, 4.0f);
            }

            prevMouseX = eventManager.mouseX;
            prevMouseY = eventManager.mouseY;
        }

        if (currentZoom < targetZoom)
        {
            currentZoom += (targetZoom - currentZoom) / zoomSmoothFactor;
            if (zoomIn)
                zoom((targetZoom - currentZoom) / zoomSmoothFactor);
            else
                zoom(-(targetZoom - currentZoom) / zoomSmoothFactor);
        }
        if (currentTranslate != targetTranslate)
        {
            Vector3f t = (targetTranslate - currentTranslate) / translateSmoothFactor;
            currentTranslate += t;
            translateTarget(t);
        }

        rotPitch = rotationQuaternion(Vector3f(1.0f, 0.0f, 0.0f), degtorad(rotPitchTheta));
        rotTurn = rotationQuaternion(Vector3f(0.0f, 1.0f, 0.0f), degtorad(rotTurnTheta));
        rotRoll = rotationQuaternion(Vector3f(0.0f, 0.0f, 1.0f), degtorad(rotRollTheta));

        Quaternionf q = rotPitch * rotTurn * rotRoll;
        Matrix4x4f rot = q.toMatrix4x4();
        invTransform = translationMatrix(Vector3f(0.0f, 0.0f, -distance)) * rot
            * translationMatrix(center);

        transform = invTransform.inverse;

        entity.prevTransformation = entity.transformation;
        entity.transformation = transform;
        entity.invTransformation = invTransform;

        entity.absoluteTransformation = entity.transformation;
        entity.invAbsoluteTransformation = entity.invTransformation;
        entity.prevAbsoluteTransformation = entity.prevTransformation;
    }

    override void onMouseWheel(int x, int y)
    {
        if (!active)
            return;

        zoom(cast(float) y * zoomSpeed);
    }
}
