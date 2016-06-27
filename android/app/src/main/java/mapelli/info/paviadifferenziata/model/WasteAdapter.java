package mapelli.info.paviadifferenziata.model;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.res.ResourcesCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import mapelli.info.paviadifferenziata.R;

/**
 * Created by francesco on 27/06/16.
 */
public class WasteAdapter extends ArrayAdapter {


    private final int resourceId;
    private final Waste[] wastes;

    public WasteAdapter(Context context, int resource, Waste[] wastes) {
        super(context, resource, wastes);
        this.resourceId = resource;
        this.wastes = wastes;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            // from scratch
            LayoutInflater inflater = LayoutInflater.from(getContext());
            convertView = inflater.inflate(resourceId, parent, false);
        }
        TextView txt = (TextView) convertView.findViewById(R.id.txt_waste_name);
        ImageView img = (ImageView) convertView.findViewById(R.id.img_waste_type);

        Waste w = wastes[position];
        txt.setText(w.getName());
        img.setImageDrawable(getWasteImage(w.getType()));


        return convertView;

    }


    private Drawable getWasteImage(Waste.Type t){
        return ResourcesCompat.getDrawable(getContext().getResources(), R.drawable
                .ic_delete_black_24dp, null);
    }
}
