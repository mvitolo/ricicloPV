package mapelli.info.paviadifferenziata;

import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomSheetBehavior;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.SearchView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ListView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import mapelli.info.paviadifferenziata.model.Waste;
import mapelli.info.paviadifferenziata.model.WasteAdapter;
import mapelli.info.paviadifferenziata.view.TodayWasteFragment;

public class DifferenziataMainActivity extends AppCompatActivity {

    private static final String TAG = DifferenziataMainActivity.class.getSimpleName();
    private FloatingActionButton fab ;
    private View bottomSheet;
    Animation growAnimation ;
    Animation shrinkAnimation;
    private WasteAdapter adapter = null;
    private ArrayList<Waste> wastes = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        growAnimation = AnimationUtils.loadAnimation(this, R.anim.simple_grow);
        shrinkAnimation = AnimationUtils.loadAnimation(this, R.anim.simple_shrink);

        setupFab();
        setupEmptyView();
        //setupBottomSheet();
        initListView();
        handleIntent(getIntent());



    }

    private void setupEmptyView() {

        Fragment todayWaste = new TodayWasteFragment();

        getSupportFragmentManager().beginTransaction().add(R.id.main_content_container,todayWaste).commit();


    }

    private void setupBottomSheet() {
        CoordinatorLayout coordinatorLayout = (CoordinatorLayout) findViewById(R.id.coordinator_layout);
        //bottomSheet = coordinatorLayout.findViewById(R.id.bottom_sheet);
        final BottomSheetBehavior behavior = BottomSheetBehavior.from(bottomSheet);
        behavior.setBottomSheetCallback(new BottomSheetBehavior.BottomSheetCallback() {
            @Override
            public void onStateChanged(@NonNull View bottomSheet, int newState) {
                switch (newState) {
                    case BottomSheetBehavior.STATE_COLLAPSED:

                        growAnimation.setAnimationListener(new Animation.AnimationListener() {
                            @Override
                            public void onAnimationStart(Animation animation) {

                            }

                            @Override
                            public void onAnimationEnd(Animation animation) {
                                fab.setVisibility(View.VISIBLE);
                            }

                            @Override
                            public void onAnimationRepeat(Animation animation) {

                            }
                        });
                        fab.startAnimation(growAnimation);
                        break;
                    case BottomSheetBehavior.STATE_EXPANDED:

                        shrinkAnimation.setAnimationListener(new Animation.AnimationListener() {
                            @Override
                            public void onAnimationStart(Animation animation) {

                            }

                            @Override
                            public void onAnimationEnd(Animation animation) {
                                fab.setVisibility(View.GONE);
                            }

                            @Override
                            public void onAnimationRepeat(Animation animation) {

                            }
                        });
                        fab.startAnimation(shrinkAnimation);
                        break;
                }
            }

            @Override
            public void onSlide(@NonNull View bottomSheet, float slideOffset) {
                // React to dragging events
                Log.e("onSlide", "onSlide");
            }
        });

        behavior.setPeekHeight(100);
    }

    private void setupFab() {
         fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d(TAG, "click!" );
            //BottomSheetBehavior.from(bottomSheet).setState(BottomSheetBehavior.STATE_EXPANDED);
            }
        });
    }

    private void initListView() {
        ListView list = (ListView) findViewById(R.id.listView);
        list.setAdapter(getListAdapter());
        list.setTextFilterEnabled(true);


    }

    private WasteAdapter getListAdapter() {
        if (adapter == null) {
            adapter = new WasteAdapter(this, R.layout.waste_row, wastes);
            loadWastes();
        }


        return adapter;
    }

    private void loadWastes() {
        AsyncTask t = new AsyncTask() {
            @Override
            protected Object doInBackground(Object[] params) {
               return getWasteList();
            }

            @Override
            protected void onPostExecute(Object o) {
                super.onPostExecute(o);
                adapter.notifyDataSetChanged();
            }
        };

        t.execute();
    }

    private boolean getWasteList() {

        InputStream inputStream = getResources().openRawResource(R.raw.newdata);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

        int ctr;
        try {
            ctr = inputStream.read();
            while (ctr != -1) {
                byteArrayOutputStream.write(ctr);
                ctr = inputStream.read();
            }
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Log.v("Text Data", byteArrayOutputStream.toString());
        try {
            // Parse the data into jsonobject to get original data in form of json.
            JSONArray jsonArray = new JSONArray(
                    byteArrayOutputStream.toString());
            String name = "";
            ArrayList<String[]> data = new ArrayList<String[]>();
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject wasteJson = jsonArray.getJSONObject(i);
                name = wasteJson.getString("Name");
                final List<Waste.DisposeOption> disposeOptions = getDisposeOptions(wasteJson);
                Log.v("name", name);
                final String finalName = name;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        adapter.add(new Waste(finalName, disposeOptions));
                        adapter.notifyDataSetChanged();
                    }
                });

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    private List<Waste.DisposeOption> getDisposeOptions(JSONObject wasteJson) {

        List<Waste.DisposeOption> disposeOptions = new ArrayList<>();

        try {
            JSONArray array = wasteJson.getJSONArray("DisposeOptions");

            for (int i = 0; i < array.length() ; i++){
                JSONObject o = array.getJSONObject(i);
                try {
                    String disposeOptionString = o.getString("disposeOption");
                    if (disposeOptionString != null && disposeOptionString.length() > 0) {
                        Waste.DisposeOption disposeOption = Waste.DisposeOption.valueOf(disposeOptionString);
                        if (disposeOption != null) {
                            disposeOptions.add(disposeOption);
                        }
                    }
                } catch (Exception e) {
                    // todo handling
                    e.printStackTrace();
                }
            }


        } catch (JSONException e) {
            e.printStackTrace();
        }


        return disposeOptions;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        // Associate searchable configuration with the SearchView
        SearchManager searchManager =
                (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        SearchView searchView =
                (SearchView) menu.findItem(R.id.menu_search).getActionView();

        if (searchManager != null && searchView != null) {
            searchView.setSearchableInfo(
                    searchManager.getSearchableInfo(getComponentName()));
        }

        if (searchView != null){
            searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
                @Override
                public boolean onQueryTextSubmit(String query) {

                    searchString(query);
                    return true;
                }

                @Override
                public boolean onQueryTextChange(String newText) {

                        searchString(newText);

                    return true;
                }
            });
        }
        return true;
    }


    private void searchString(String s) {
        Log.d(TAG, "search for " + s);
        getListAdapter().getFilter().filter(s, null);
        getListAdapter().notifyDataSetChanged();
        if (s.isEmpty()) {
            findViewById(R.id.listView).setVisibility(View.GONE);
        } else {
            findViewById(R.id.listView).setVisibility(View.VISIBLE);
        }

    }


















    @Override
    protected void onNewIntent(Intent intent) {
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        if (Intent.ACTION_SEARCH.equals(intent.getAction())){
            String q = intent.getStringExtra(SearchManager.QUERY);
            Log.d(TAG, "got intent with query " + q);
        searchString(q);
        } else {
            super.onNewIntent(intent);
        }
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();



        return super.onOptionsItemSelected(item);
    }
}
