package mapelli.info.paviadifferenziata.model;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.res.ResourcesCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import mapelli.info.paviadifferenziata.R;
import mapelli.info.paviadifferenziata.controller.Utils;

/**
 * Created by francesco on 27/06/16.
 */
public class WasteAdapter extends ArrayAdapter implements Filterable {


    private final int resourceId;
    private final Context context;
    private ArrayList<Waste> mOriginalValues ;
    private List<Waste> mObjects = new ArrayList<Waste>();
    private Object mLock = new Object();
    private Filter mFilter;


    public WasteAdapter(Context context, int resource, List<Waste> wastes) {
        super(context, resource, wastes);
        this.context = context;
        this.resourceId = resource;
        mObjects.clear();
        mObjects.addAll(wastes);
        // original values array is not filled yet, it will be created when needed the
        // first time we filter the items

    }

    @Override
    public int getCount() {
        if (mObjects == null) {
            return 0;
        }
        return mObjects.size();
    }

    @Override
    public Object getItem(int position) {
        return mObjects.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
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

        Waste w = (Waste) getItem(position);
        txt.setText(Utils.capitalize(w.getName()));
        if (w.getDisposeOptions().size() > 0) {
            img.setImageDrawable(getWasteImage(w.getDisposeOptions().get(0)));
        }


        return convertView;

    }


    @Override
    public void add(Object object) {
        synchronized (mLock) {
            if (mOriginalValues != null) {
                mOriginalValues.add((Waste) object);
            } else {
                mObjects.add((Waste) object);
            }
        }
        notifyDataSetChanged();
    }

    private Drawable getWasteImage(Waste.DisposeOption t){

        int resId = R.drawable.ic_delete_48dp;

        switch (t) {
            case PAPER:
                resId = R.drawable.carta;
                break;
            case HUMID:
                resId = R.drawable.umido;
                break;
            case PLASTIC:
                resId = R.drawable.plastica;
                break;
            case GLASS:
                resId = R.drawable.vetro;
                break;
            case GENERIC:
                resId = R.drawable.secco;
                break;

        }

        return ResourcesCompat.getDrawable(getContext().getResources(), resId, null);
    }

    @Override
    public Filter getFilter() {
        if (mFilter == null) {
            mFilter = new WasteFilter();
        }
        return mFilter;
    }

    public Context getContext() {
        return context;

    }

    private class WasteFilter extends Filter {
        @Override
        protected FilterResults performFiltering(CharSequence filterString) {
            FilterResults results = new FilterResults();

            if (mOriginalValues == null) {
                synchronized (mLock) {
                    mOriginalValues = new ArrayList<Waste>(mObjects);
                }
            }

            if (filterString == null || filterString.length() == 0) {
                ArrayList<Waste> list;
                synchronized (mLock) {
                    list = new ArrayList<Waste>(mOriginalValues);
                }
                results.values = list;
                results.count = list.size();
            } else {
                String searchString = filterString.toString().toLowerCase();
                ArrayList<Waste> values;
                synchronized (mLock) {
                    values = new ArrayList<Waste>(mOriginalValues);
                }

                final int count = values.size();
                final ArrayList<Waste> newValues = new ArrayList<Waste>();

                for (int i = 0; i < count; i++) {
                    final Waste value = values.get(i);
                    final String valueText = value.toString().toLowerCase();

                    // First match against the whole, non-splitted value
                    if (valueText.contains(searchString)) {
                        newValues.add(value);
                    } else {
                        final String[] words = valueText.split(" ");
                        final int wordCount = words.length;

                        // Start at index 0, in case valueText starts with space(s)
                        for (int k = 0; k < wordCount; k++) {
                            if (words[k].startsWith(searchString)) {
                                newValues.add(value);
                                break;
                            }
                        }
                    }
                }

                results.values = newValues;
                results.count = newValues.size();
            }

            return results;
        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            //noinspection unchecked
            mObjects = (List<Waste>) results.values;
            if (results.count > 0) {
                notifyDataSetChanged();
            } else {
                notifyDataSetInvalidated();
            }
        }
    }
}
