package mapelli.info.paviadifferenziata.view;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import mapelli.info.paviadifferenziata.R;


public class TodayWasteFragment extends Fragment {

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {


        View mainView = inflater.inflate(R.layout.fra_today_waste, container, false);

        return mainView;

    }
}
